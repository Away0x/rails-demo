class AvatarUploader < ImageUploader
  # 使用 carrierwave
  # rails g uploader avatar
  version :thumb do
    process resize_to_fill: [160, 160]
  end
end
