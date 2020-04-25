# frozen_string_literal: true

# User model used to represent registered User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # email:string
  # name:string
  # admin:boolean
  # deleted_at:datetime

  # Short display name for user
  def first_name
    namae.given
  end

  # Display image for user
  def image
    return unless email?

    require "digest/md5"
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://s.gravatar.com/avatar/#{hash}?s=480"
  end

  # instead of deleting users, mark them as soft deleted
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # [devise] ensure user account is active
  def active_for_authentication?
    super && !deleted_at?
  end

  # [devise] provide a custom message for a soft-deleted account
  def inactive_message
    !deleted_at? ? super : :deleted_account
  end

  def to_s
    # Use the stored name value for labels
    (name_changed? ? name_was : name) || super
  end

  private

  def namae
    @namae ||= Namae::Name.parse(name)
  end
end
