class User < ApplicationRecord
  before_create :prepare_email_verification

  def email_verified?
    email_verified_at.present?
  end

  def verify_email!
    update!(
      email_verified_at: Time.current,
      email_verification_token: nil
    )
  end

  def regenerate_email_verification!
    update!(
      email_verification_token: generate_email_verification_token,
      email_verification_sent_at: Time.current
    )
  end

  def email_verification_expired?
    email_verification_sent_at.blank? ||
      email_verification_sent_at < 24.hours.ago
  end

  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :memberships,
            dependent: :destroy

  has_many :accounts,
            through: :memberships

  normalizes :email_address,
              with: ->(email) {
                email.strip.downcase
              }

  validates  :email_address,
             presence: true,
             uniqueness: { case_sensitive: false }

  private

  def prepare_email_verification
    self.email_verification_token ||=
      generate_email_verification_token

    self.email_verification_sent_at ||=
      Time.current
  end

  def generate_email_verification_token
    loop do
      token =
        SecureRandom.urlsafe_base64(32)

      break token unless User.exists?(
        email_verification_token: token
      )
    end
  end
end
