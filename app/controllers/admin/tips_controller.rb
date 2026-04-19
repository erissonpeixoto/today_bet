module Admin
  class TipsController < BaseController
    before_action :set_match

    def index
      @market_groups = @match.tips.includes(:user).group_by(&:market)
    end

    def set_result
      market = params[:market]
      correct = params[:correct] == "true" ? true : params[:correct] == "false" ? false : nil
      count = @match.tips.where(market: market).update_all(correct: correct)
      label = Tip::MARKET_LABELS[market] || market
      redirect_to admin_match_tips_path(@match), notice: "#{label}: #{count} palpite(s) atualizado(s)."
    end

    private

    def set_match
      @match = Match.find(params[:match_id])
    end
  end
end
