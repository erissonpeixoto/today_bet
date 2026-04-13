class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tip

  def create
    vote_type = params[:vote_type]
    @vote = @tip.votes.find_by(user: current_user, vote_type: vote_type)

    if @vote
      @vote.destroy
    else
      @tip.votes.create!(user: current_user, vote_type: vote_type)
    end

    @tip.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: match_path(@tip.match) }
    end
  end

  private

  def set_tip
    @tip = Tip.find(params[:tip_id])
  end
end
