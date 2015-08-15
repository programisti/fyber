require 'rails_helper'

RSpec.describe OffersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      post :create, { offer_request: { "uid"=>"333", "pub0"=>"", "page"=>"" } }
      expect(response).to have_http_status(:success)
    end

    it "render new" do
      post :create, { offer_request: { "uid"=>"", "pub0"=>"", "page"=>"" } }
      expect(response).to render_template(:new)
    end
  end

end
