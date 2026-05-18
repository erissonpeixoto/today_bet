module Admin
  class CupMatchesController < Admin::BaseController
    before_action :set_cup_match, only: [ :edit, :update, :destroy, :set_result ]

    def index
      @cup_matches = CupMatch.includes(:home_club, :away_club).order(:match_date)
    end

    def new
      @cup_match = CupMatch.new
    end

    def create
      @cup_match = CupMatch.new(cup_match_params)
      if @cup_match.save
        redirect_to admin_cup_matches_path, notice: "Partida da Copa criada."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @cup_match.update(cup_match_params)
        redirect_to admin_cup_matches_path, notice: "Partida atualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @cup_match.destroy
      redirect_to admin_cup_matches_path, notice: "Partida removida."
    end

    def set_result
      if @cup_match.update(result_params.merge(status: :finished))
        redirect_to admin_cup_matches_path, notice: "Resultado salvo e palpites calculados automaticamente."
      else
        redirect_to admin_cup_matches_path, alert: "Erro ao salvar resultado."
      end
    end

    private

    def set_cup_match
      @cup_match = CupMatch.find(params[:id])
    end

    def cup_match_params
      params.require(:cup_match).permit(
        :home_club_id, :away_club_id, :group_name, :phase, :match_date, :venue, :status
      )
    end

    def result_params
      params.require(:cup_match).permit(:home_score, :away_score)
    end
  end
end
