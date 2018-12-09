# frozen_string_literal: true
class ApplicationResource < JSONAPI::Resource
  abstract

  private

  def current_user
    context.fetch(:current_user)
  end

  class << self
    private

    def current_user(options)
      options.fetch(:context).fetch(:current_user)
    end
  end
end
