module Admin
  class FootballClubsController < BaseController
    before_action :set_club, only: [ :edit, :update, :destroy ]

    def index
      @clubs = FootballClub.order(:name)
    end

    def new
      @club = FootballClub.new
    end

    def create
      @club = FootballClub.new(club_params)
      if @club.save
        redirect_to admin_football_clubs_path, notice: "Clube criado com sucesso!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @club.update(club_params)
        redirect_to admin_football_clubs_path, notice: "Clube atualizado!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @club.destroy
      redirect_to admin_football_clubs_path, notice: "Clube removido."
    end

    private

    def set_club
      @club = FootballClub.find(params[:id])
    end

    def club_params
      params.require(:football_club).permit(:name, :logo_url)
    end
  end
end
