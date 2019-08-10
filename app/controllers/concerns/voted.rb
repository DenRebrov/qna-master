module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: %i[like dislike]
  end

  def like
    @resource.add_like if !current_user.author_of?(@resource)

    render json: { id: @resource.id, rating: @resource.rating }
  end

  def dislike
    @resource.add_dislike if !current_user.author_of?(@resource)

    render json: { id: @resource.id, rating: @resource.rating }
  end

  private

  def find_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end