class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :account
  attribute :shop
  attribute :membership
  attribute :user

  delegate :user,
    to: :session,
    allow_nil: true
end
