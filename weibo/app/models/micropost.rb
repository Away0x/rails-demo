class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image # active storage

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,
            content_type: {
              in: %w[image/jpeg image/gif image/png],
              message: "must be a valid image format",
            },
            size: {
              less_than: 5.megabytes,
              message: "should be less than 5MB",
            }

  # 返回调整尺寸后的图像，供显示
  def display_image
    # 需要 https://www.imagemagick.org/ (brew install imagemagick)
    # gem 'image_processing'
    # gem 'mini_magick'
    image.variant(resize_to_limit: [500, 500])
  end

end
