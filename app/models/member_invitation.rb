class MemberInvitation < ApplicationRecord
  belongs_to :account
  belongs_to :invited_by, class_name: "User"

  ROLE = %w[
    admin
    manager
    staff
  ].freeze


  validates :email, presence: true

  validates :role, presence: true, inclusion: { in: ROLE }

  validates :token, presence: true, uniqueness: true

  before_validation :normalize_email
  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  def accepted?
    accepted_at.present?
  end

  def expired?
    expires_at < Time.current
  end

  private

  def normalize_email
    self.email =
      email.to_s
           .strip
           .downcase
  end

  def generate_token
    self.token ||=
      SecureRandom.urlsafe_base64(32)
  end

  def set_expiration
    self.expires_at ||=
      7.days.from_now
  end
end
