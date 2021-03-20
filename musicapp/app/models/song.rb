class Song < ApplicationRecord
  include Searchable

  validates :name, :file_path, :md5_hash, presence: true

  belongs_to :album, touch: true
  belongs_to :artist, touch: true
end
