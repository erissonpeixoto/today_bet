class TipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match

  def create
    @tip = @match.tips.build(tip_params.merge(user: current_user))

    if @tip.save
      redirect_to @match, notice: "Palpite publicado com sucesso!"
    else
      @tips = @match.tips.includes(:user).most_hot
      render "matches/show", status: :unprocessable_entity
    end
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end

  def tip_params
    params.require(:tip).permit(:market, :confidence, :justification)
  end
end
