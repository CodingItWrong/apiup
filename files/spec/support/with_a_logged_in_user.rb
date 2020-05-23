# frozen_string_literal: true

RSpec.shared_context 'with a logged in user' do
  let!(:user) { FactoryBot.create(:user) }
  let!(:token) do
    FactoryBot.create(:access_token, resource_owner_id: user.id).token
  end
  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/vnd.api+json',
    }
  end
end
