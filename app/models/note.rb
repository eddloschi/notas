class Note < ActiveRecord::Base
  @allowed_colors = %w(Gold LightGreen Pink SkyBlue)

  validates :body, presence: true
  validates :color, inclusion: {in: @allowed_colors}

  belongs_to :user

  class << self
    attr_reader :allowed_colors
  end
end
