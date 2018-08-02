# frozen_string_literal: true
class UserResource < ApplicationResource
  attributes *%i[email password]
end
