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

  delegate :given, :family, to: :namae

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
    (name_changed? ? name_was : name) || (id? ? "User ##{id}" : "Guest User")
  end

  private

  def namae
    @namae ||= Namae::Name.parse(name)
  end
end
