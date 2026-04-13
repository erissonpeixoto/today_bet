module Admin
  class MatchesController < BaseController
    before_action :set_match, only: [:edit, :update, :destroy]

    def index
      @pagy, @matches = pagy(Match.order(match_date: :desc), items: 20)
    end

    def new
      @match = Match.new
    end

    def create
      @match = Match.new(match_params)
      if @match.save
        redirect_to admin_matches_path, notice: "Jogo criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @match.update(match_params)
        redirect_to admin_matches_path, notice: "Jogo atualizado!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @match.destroy
      redirect_to admin_matches_path, notice: "Jogo removido."
    end

    private

    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:home_team, :away_team, :league, :match_date, :status)
    end
  end
end
