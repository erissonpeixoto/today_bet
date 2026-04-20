class MatchesController < ApplicationController
  def index
    @pagy, @matches = pagy(Match.order(:match_date), items: 12)
    @top_users   = User.ranked.limit(5)
    @hottest_tip = Tip.order(
      Arel.sql("votes_agree_count + votes_hot_count + votes_disagree_count DESC")
    ).includes(:user, :match).first
  end

  def show
    @match = Match.find(params[:id])
    @tips  = @match.tips.includes(:user).most_hot
    @tip   = Tip.new if user_signed_in?
  end
end
