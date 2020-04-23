# frozen_string_literal: true

# Policy for updating profiles, provided by rockstart
class UserPolicy < ApplicationPolicy
  # def index?
  #   false
  # end

  # def show?
  #   false
  # end

  # def create?
  #   false
  # end

  def update?
    current_user?
  end

  def destroy?
    # Prevent admins from destroying themselves
    current_user? && !record.admin?
  end

  def permitted_attributes
    if current_user?
      # Allow a user to update their own details
      %i[name]
    else
      []
    end
  end

  private

  def current_user?
    user.persisted? && user.id == record.id
  end

  # Safe scope for User
  class Scope < Scope
    def resolve
      user.persisted? ? scope.where(id: user.id) : scope.none
    end
  end
end
