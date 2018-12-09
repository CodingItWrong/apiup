# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'registering', type: :request do
  let(:headers) {
    {
      'Content-Type' => 'application/vnd.api+json',
    }
  }

  it 'allows creating a user' do
    email = 'example@example.com'
    password = 'mypassword'

    params = {
      data: {
        type: 'users',
        attributes: {
          email: email,
          password: password,
        },
      },
    }

    post '/users', params: params.to_json, headers: headers

    expect(response.status).to eq(201)
    expect(User.count).to eq(1)
  end
end
