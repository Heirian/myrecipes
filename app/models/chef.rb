class Chef < ApplicationRecord
  before_save   :downcase_email
  validates :chefname, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
end
