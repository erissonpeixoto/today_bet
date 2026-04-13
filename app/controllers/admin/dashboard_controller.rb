module Admin
  class DashboardController < BaseController
    def index
      @matches_count = Match.count
      @tips_count    = Tip.count
      @users_count   = User.count
      @recent_matches = Match.recent.limit(5)
    end
  end
end
