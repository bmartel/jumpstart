class User < ApplicationRecord
  self.implicit_order_column = "created_at"
  before_create :attach_preferences

  include Gravtastic

  GRAVATAR_OPTIONS = { default: 'identicon', size: 256, rating: 'PG' }

  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable, :invitable, :lockable, :validatable, :omniauthable

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :services, dependent: :destroy
  has_one :preference, foreign_key: :user_id, class_name: 'UserPreference', dependent: :destroy
  has_one_attached :image, dependent: :destroy

  gravtastic :email

  def avatar
    return self.image if self.image.attached?

    self.avatar_url || gravatar_url(GRAVATAR_OPTIONS)
  end

  def as_json(*)
    super.except("created_at", "updated_at").tap do |hash|
      hash["avatar"] = avatar
    end
  end

  private
  def attach_preferences
    # ensure user has a default set of options that can be customized further
    self.build_preference
  end
end
