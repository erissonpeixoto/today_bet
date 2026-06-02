module Cup
  class PoolsController < BaseController
    skip_before_action :authenticate_user!, only: [ :index ]
    before_action :set_pool, only: [ :show ]

    def index
      @public_pools = CupPool.where(private: false)
                             .includes(:cup_pool_memberships)
                             .order(created_at: :desc)
                             .limit(10)
      if user_signed_in?
        @pools = current_user.cup_pool_memberships
                             .includes(:cup_pool)
                             .order(created_at: :desc)
                             .map(&:cup_pool)
      end
    end

    def show
      unless @pool.member?(current_user)
        redirect_to cup_root_path, alert: "Você não faz parte deste bolão."
        return
      end

      @memberships = @pool.cup_pool_memberships
                          .includes(:user)
                          .order(total_score: :desc)
      @matches     = CupMatch.includes(:home_club, :away_club).order(:match_date)
      @user_guesses = @pool.cup_guesses
                           .where(user: current_user)
                           .index_by(&:cup_match_id)
    end

    def new
      @pool = CupPool.new
    end

    def create
      @pool = CupPool.new(pool_params.merge(creator: current_user))
      if @pool.save
        @pool.cup_pool_memberships.create!(user: current_user, role: :owner)
        redirect_to cup_pool_path(@pool),
          notice: "Bolão criado! Compartilhe o código #{@pool.invite_code} com seus amigos."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_pool
      @pool = CupPool.find(params[:id])
    end

    def pool_params
      params.require(:cup_pool).permit(:name, :description, :private)
    end
  end
end
