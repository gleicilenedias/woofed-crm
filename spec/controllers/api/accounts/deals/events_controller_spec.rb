require 'rails_helper'

RSpec.describe 'Events API', type: :request do
  let!(:account) { create(:account) }
  let!(:user) { create(:user) }
  let!(:deal) { create(:deal) }
  let(:last_event) { Event.last }
  let(:auth_headers) { { 'Authorization': "Bearer #{user.get_jwt_token}", 'Content-Type': 'application/json' } }

  describe 'POST /api/v1/accounts/:account_id/deals/:deal_id/events' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        expect do
          post "/api/v1/accounts/#{account.id}/deals/#{deal.id}/events", params: {}
        end.to change(Event, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      let(:params) { { kind: 'activity', content: 'Test content', auto_done: true }.to_json }

      it 'creates event with valid params' do
        expect do
          post "/api/v1/accounts/#{account.id}/deals/#{deal.id}/events", params:, headers: auth_headers
        end.to change(Event, :count).by(1)
        expect(response).to have_http_status(:created)
        result = JSON.parse(response.body)
        expect(result['kind']).to eq('activity')
        expect(result['auto_done']).to be true
        expect(last_event.deal_id).to eq(deal.id)
        expect(last_event.contact).to eq(deal.contact)
        expect(last_event.account).to eq(account)
        expect(last_event.from_me).to be true
      end

      context 'when params are invalid' do
        it 'returns unprocessable_entity with errors' do
          params = { kind: nil, content: '' }.to_json

          expect do
            post "/api/v1/accounts/#{account.id}/deals/#{deal.id}/events", params:, headers: auth_headers
          end.to change(Event, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']).to include("Type can't be blank")
        end
      end

      context 'when deal is not found' do
        it 'returns not found' do
          expect do
            post "/api/v1/accounts/#{account.id}/deals/9999/events", params:, headers: auth_headers
          end.to change(Event, :count).by(0)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
