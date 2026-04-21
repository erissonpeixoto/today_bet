class MatchesController < ApplicationController
  def show
    @match = Match.find(params[:id])
    @tips  = @match.tips.includes(:user).most_hot
    @tip   = Tip.new if user_signed_in?
  end
end
