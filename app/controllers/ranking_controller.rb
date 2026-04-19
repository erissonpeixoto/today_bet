class RankingController < ApplicationController
  def index
    @top_users = User.ranked.limit(100)
  end
end
