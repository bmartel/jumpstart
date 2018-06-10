class User < ApplicationRecord
  include Gravtastic

  default_scope { with_attached_image }

  GRAVATAR_OPTIONS = { default: 'identicon', size: 256, rating: 'PG' }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable, :invitable, :lockable, :validatable, :omniauthable

  has_many :notifications, foreign_key: :recipient_id
  has_many :services
  has_one_attached :image

  gravtastic :email

  def avatar
    return self.image if self.image.attached?
    gravatar_url(GRAVATAR_OPTIONS)
  end

  def as_json(*)
    super.except("created_at", "updated_at").tap do |hash|
      hash["avatar"] = avatar
    end
  end
end
