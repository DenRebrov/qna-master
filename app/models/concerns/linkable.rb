module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :links, dependent: :destroy, as: :linkable
  end
end