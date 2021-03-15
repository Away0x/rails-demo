class Current < ActiveSupport::CurrentAttributes
  # https://ruby-china.org/topics/33300
  attribute :user, :identity, :site
end
