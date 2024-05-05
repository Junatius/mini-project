require 'rails_helper'

RSpec.describe 'Conversations API', type: :request do
  include ControllerSpecHelper
  include RequestSpecHelper

  let!(:dimas) { create(:user) }
  let!(:dimas_headers) { valid_headers(dimas.id) }

  let!(:samid) { create(:user) }
  let!(:samid_headers) { valid_headers(samid.id) }

  describe 'GET /conversations' do
    context 'when user has no conversation' do
      before { get '/conversations', params: {}, headers: dimas_headers }

      it 'returns empty data with 200 code' do
        expect(response_body).to eq({ "data" => [] })
      end
    end

    context 'when user has conversations' do
      before do
        create_list(:conversation, 5, sender: dimas) do |conversation|
          create(:chat, conversation: conversation, sender: dimas)
          create(:user_conversation, conversation: conversation, user: dimas)
        end
        get '/conversations', params: {}, headers: dimas_headers
      end

      it 'returns list conversations of current user' do
        expect(response_data).not_to be_empty
        expect(response_data.size).to eq(5)
      end

      it 'returns status code 200 with correct response' do
        expect(response_body).to eq({
          "data" => [
            {
              "id" => Integer,
              "last_message" => {
                "id" => Integer,
                "sender" => {
                  "id" => Integer,
                  "name" => String
                },
                "sent_at" => String
              },
              "unread_count" => Integer,
              "with_user" => {
                "id" => Integer,
                "name" => String,
                "photo_url" => String
              }
            }
          ]
        })
      end

    end
  end

  describe 'GET /conversations/:id' do
    let!(:convo_id) do
      convo = create(:conversation, sender: dimas)
      create(:chat, conversation: convo, sender: dimas)
      create(:user_conversation, conversation: convo, user: dimas)
      convo.id
    end

    context 'when the record exists' do
      before do
        get "/conversations/#{convo_id}", params: {}, headers: dimas_headers
      end

      it 'returns conversation detail' do
        expect(response_body).to eq({
          "data" => {
            "id" => Integer,
            "with_user" => {
              "id" => Integer,
              "name" => String,
              "photo_url" => String
            }
          }
        })
      end

    end

    context 'when current user accesses other user conversation' do
      before do
        @convo_id = create(:conversation, sender: dimas).id
        get "/conversations/#{@convo_id}", params: {}, headers: samid_headers
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record does not exist' do
      before { get "/conversations/-11", params: {}, headers: dimas_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
