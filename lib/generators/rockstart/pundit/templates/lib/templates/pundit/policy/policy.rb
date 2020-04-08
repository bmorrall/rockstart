# frozen_string_literal: true

<% module_namespacing do -%>
class <%= class_name %>Policy < ApplicationPolicy
  def index?
    user.persisted?
  end

  def show?
    user.persisted?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def permitted_attributes
    super
  end

  # Safe scope for <%= class_name %>
  class Scope < Scope
    def resolve
      user.persisted? ? scope.all : scope.none
    end
  end
end
<% end -%>
