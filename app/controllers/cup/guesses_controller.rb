module Cup
  class GuessesController < BaseController
    before_action :set_pool
    before_action :require_membership

    def index
      @matches      = CupMatch.includes(:home_club, :away_club).order(:match_date)
      @user_guesses = @pool.cup_guesses
                           .where(user: current_user)
                           .index_by(&:cup_match_id)
    end

    def create
      @match = CupMatch.find(guess_params[:cup_match_id])
      @guess = @pool.cup_guesses.find_or_initialize_by(cup_match: @match, user: current_user)

      if @guess.locked?
        redirect_to cup_pool_guesses_path(@pool), alert: "Palpite bloqueado — partida já iniciada."
        return
      end

      @guess.assign_attributes(
        home_score_guess: guess_params[:home_score_guess],
        away_score_guess: guess_params[:away_score_guess]
      )

      if @guess.save
        redirect_to cup_pool_guesses_path(@pool), notice: "Palpite salvo!"
      else
        redirect_to cup_pool_guesses_path(@pool), alert: @guess.errors.full_messages.to_sentence
      end
    end

    def update
      @guess = @pool.cup_guesses.find(params[:id])

      if @guess.locked?
        redirect_to cup_pool_guesses_path(@pool), alert: "Palpite bloqueado."
        return
      end

      if @guess.update(home_score_guess: guess_params[:home_score_guess],
                       away_score_guess: guess_params[:away_score_guess])
        redirect_to cup_pool_guesses_path(@pool), notice: "Palpite atualizado!"
      else
        redirect_to cup_pool_guesses_path(@pool), alert: @guess.errors.full_messages.to_sentence
      end
    end

    private

    def set_pool
      @pool = CupPool.find(params[:pool_id])
    end

    def require_membership
      unless @pool.member?(current_user)
        redirect_to cup_root_path, alert: "Você não faz parte deste bolão."
      end
    end

    def guess_params
      params.require(:cup_guess).permit(:cup_match_id, :home_score_guess, :away_score_guess)
    end
  end
end
