require 'rails_helper'

RSpec.describe OfferRequest, type: :model do
  it 'is not valid without uid' do
    offer_request = OfferRequest.new({})

    expect(offer_request.valid?).to eq(false)
  end

  it 'creates a new OfferRequest with appid and timestamp' do
    offer_request = OfferRequest.new uid: '333',
                                     page: 1,
                                     apple_idfa: '2b6f0cc904d137be2e1730235f5664094b83',
                                     locale: 'de',
                                     ip: '109.235.143.113',
                                     os_device: '8.0',
                                     apple_idfa_tracking_enabled: true,
                                     format: 'json',
                                     offer_types: 112,
                                     pub0: ''

    expect(offer_request.params[:appid]).to eq(157)
    expect(offer_request.params[:timestamp]).to be_kind_of(Integer)
  end

  it 'should return right URL' do
    offer_request = OfferRequest.new uid: '333',
                                     page: 1,
                                     apple_idfa: '2b6f0cc904d137be2e1730235f5664094b83',
                                     locale: 'de',
                                     ip: '109.235.143.113',
                                     os_device: '8.0',
                                     apple_idfa_tracking_enabled: true,
                                     format: 'json',
                                     offer_types: 112,
                                     pub0: ''

    offer_request.params[:timestamp] = 1437150543 # Set unchanged timestamp

    expect(offer_request.url).to eq "http://api.sponsorpay.com/feed/v1/offers.json?appid=157&apple_idfa=2b6f0cc904d137be2e1730235f5664094b83&apple_idfa_tracking_enabled=true&ip=109.235.143.113&locale=de&offer_types=112&os_device=8.0&page=1&pub0=&timestamp=1437150543&uid=333&hashkey=0c495c7d40b0d7eb2d6b7bc72bddb1f562717e67"
  end

  it "returns message when status is not 200" do
    offer_request = OfferRequest.new({})

    fake = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/test') { |env| [400, {}, "{\"code\":\"ERROR_INVALID_HASHKEY\",\"message\":\"An invalid hashkey for this appid was given as a parameter in the request.\"}"] }
      end
    end

    expect(offer_request.handle(fake.get '/test')).to eq("An invalid hashkey for this appid was given as a parameter in the request.")
  end

  it "returns message when status is 200 but offers is empty" do
    offer_request = OfferRequest.new({})

    fake = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/test') { |env| [200, {}, "{\"code\":\"NO_CONTENT\",\"message\":\"Successful request, but no offers are currently available for this user.\",\"count\":0,\"pages\":0,\"information\":{\"app_name\":\"Demo iframe for publisher - do not touch\",\"appid\":157,\"virtual_currency\":\"Coins\",\"country\":\"DE\",\"language\":\"DE\",\"support_url\":\"http://offer.fyber.com/mobile/support?appid=157&client=api&uid=333\"},\"offers\":[]}" ] }
      end
    end

    expect(offer_request.handle(fake.get '/test')).to eq("Successful request, but no offers are currently available for this user.")
  end

  it "returns offers when status is 200 but offers is not empty" do
    offer_request = OfferRequest.new({})

    fake = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('/test') { |env| [200, {}, "{\"code\":\"NO_CONTENT\",\"message\":\"Successful request, but no offers are currently available for this user.\",\"count\":0,\"pages\":0,\"information\":{\"app_name\":\"Demo iframe for publisher - do not touch\",\"appid\":157,\"virtual_currency\":\"Coins\",\"country\":\"DE\",\"language\":\"DE\",\"support_url\":\"http://offer.fyber.com/mobile/support?appid=157\\u0026client=api\\u0026uid=333\"},\"offers\":[1,2,3]}" ] }
      end
    end

    expect(offer_request.handle(fake.get '/test')).to eq([1,2,3])
  end
end
