# frozen_string_literal: true

# User model used to represent registered User
class User < ApplicationRecord
  # name:string
  # admin:boolean

  delegate :given, :family, to: :namae

  def to_s
    # Use the stored name value for labels
    (name_changed? ? name_was : name) || (id? ? "User ##{id}" : "Guest User")
  end

  private

  def namae
    @namae ||= Namae::Name.parse(name)
  end
end
