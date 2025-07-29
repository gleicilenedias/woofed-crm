require 'rails_helper'

RSpec.describe 'Accounts API', type: :request do
  let!(:account) { create(:account) }
  let!(:user) { create(:user, account:) }
  let(:response_body) { JSON.parse(response.body) }

  describe 'GET /api/v1/accounts/{account.id}' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      context 'get account' do
        it do
          get "/api/v1/accounts/#{account.id}",
               headers: { 'Authorization': "Bearer #{user.get_jwt_token}" }

          expect(response).to have_http_status(:success)
          expect(response_body['name']).to eq(account.name)
        end
      end
    end
  end

  describe 'PATCH /api/v1/accounts/{account.id}' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        patch "/api/v1/accounts/#{account.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      context 'update account' do
        let(:new_name) { 'Updated Account Name' }

        it do
          patch "/api/v1/accounts/#{account.id}",
                params: { name: new_name },
                headers: { 'Authorization': "Bearer #{user.get_jwt_token}" }

          expect(response).to have_http_status(:success)
          expect(response_body['name']).to eq(new_name)
        end

        it 'returns unprocessable entity for invalid params' do
          patch "/api/v1/accounts/#{account.id}",
                params: { name: '' },
                headers: { 'Authorization': "Bearer #{user.get_jwt_token}" }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body['errors']).to include("Name can't be blank")
        end
      end
    end
  end
end
