class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tip

  def create
    @comment = @tip.comments.build(content: params[:content], user: current_user)

    if @comment.save
      @tip.reload
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: match_path(@tip.match) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_error_#{@tip.id}", partial: "comments/error", locals: { tip: @tip, errors: @comment.errors }) }
        format.html { redirect_back fallback_location: match_path(@tip.match), alert: @comment.errors.full_messages.join(", ") }
      end
    end
  end

  private

  def set_tip
    @tip = Tip.find(params[:tip_id])
  end
end
