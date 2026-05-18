module Cup
  class JoinsController < BaseController
    def show
      @pool = CupPool.find_by(invite_code: params[:code].upcase)
      unless @pool
        redirect_to cup_root_path, alert: "Código de convite inválido."
        return
      end
      redirect_to cup_pool_path(@pool), notice: "Você já está neste bolão!" if @pool.member?(current_user)
    end

    def create
      @pool = CupPool.find_by(invite_code: params[:code].upcase)
      unless @pool
        redirect_to cup_root_path, alert: "Código de convite inválido."
        return
      end

      if @pool.member?(current_user)
        redirect_to cup_pool_path(@pool), notice: "Você já está neste bolão!"
        return
      end

      @pool.cup_pool_memberships.create!(user: current_user, role: :member)
      redirect_to cup_pool_path(@pool), notice: "Bem-vindo ao bolão #{@pool.name}!"
    end
  end
end
