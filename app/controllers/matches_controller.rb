class MatchesController < ApplicationController
  def index
    @pagy, @matches = pagy(Match.order(:match_date), items: 12)
  end

  def show
    @match = Match.find(params[:id])
    @tips  = @match.tips.includes(:user).most_hot
    @tip   = Tip.new if user_signed_in?
  end
end
