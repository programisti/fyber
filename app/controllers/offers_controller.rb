class OffersController < ApplicationController
  def new
    @offer_request = OfferRequest.new({})
  end

  def create
    @offer_request = OfferRequest.new params[:offer_request].merge(default_params)

    render 'new' and return unless @offer_request.valid?

    if (@content = @offer_request.launch).is_a?(String)
      render text: @content
    else
      render 'show'
    end
  end

  private

  def default_params
    {
      apple_idfa: '2b6f0cc904d137be2e1730235f5664094b83',
      locale: 'de',
      ip: '109.235.143.113',
      os_device: '8.0',
      apple_idfa_tracking_enabled: true,
      format: 'json',
      offer_types: 112
    }.freeze
  end
end
