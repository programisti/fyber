class OfferRequest
  include ActiveModel::Model

  BASE_URL = 'http://api.sponsorpay.com/feed/v1/offers'.freeze

  attr_accessor :uid, :pub0, :page, :params

  validates :uid, presence: true

  def initialize request_params
    @params = request_params
    @uid = request_params[:uid]
    @page = request_params[:page]
    @pub0 = request_params[:pub0]

    @params[:appid] = Rails.application.secrets.appid
    @params[:timestamp] = Time.now.to_i
  end

  def launch
    handle Faraday.get(url)
  end

  def url
    query_string = params.except(:format).sort.to_h.to_query

    hashkey = Digest::SHA1.hexdigest("#{query_string}&#{Rails.application.secrets.api_key}")

    "#{BASE_URL}.#{params[:format]}?#{query_string}&hashkey=#{hashkey}"
  end

  def handle response
    response_body = JSON.parse response.body

    case response.status
    when 200
      return response_body['offers'].blank? ? response_body['message'] : response_body['offers']
    when 400, 401, 404, 500, 502
      return response_body['message']
    end
  end
end
