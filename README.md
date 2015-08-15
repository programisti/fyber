# Basic information
* Please visit http://fyber.spacelions.com

# Thoughts
## ActiveModel as model
As this is a Rails project without database, ActiveModel is the only choice.
The goal is to extract __"make the request to the API passing the params and the authentication hash"__ idea into a tableless model.

Since there would be a form asking for uid/pub0/page, it indicates I should create a model for OfferRequest, which instance variables would be request parameters. And its only action is to send request to Fyber server.

## Skinny controller only for flows, no business logic
According to different results returned by OfferRequest, controller only deals with flows, like render/redirect_to.
