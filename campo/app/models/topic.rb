class Topic < ApplicationRecord
  include Trashable

  belongs_to :forum, touch: true
  belongs_to :user

  before_create :set_activated_at
  after_create :increment_topics_count
  after_trash :decrement_topics_count
  after_restore :increment_topics_count

  validates :title, presence: true

  private

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end

  def increment_topics_count
    Forum.increment_counter :topics_count, forum_id, touch: true
  end

  def decrement_topics_count
    Forum.decrement_counter :topics_count, forum_id, touch: true
  end
end
