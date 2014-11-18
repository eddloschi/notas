class Note < ActiveRecord::Base
    @allowed_colors = [
    "Gold",
    "LightGreen",
    "Pink",
    "SkyBlue"
  ]

  validates :body, presence: true
  validates :color, inclusion: { in: @allowed_colors }

  belongs_to :user
end
