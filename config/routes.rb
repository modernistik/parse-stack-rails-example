Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    # see app/models/webhooks.rb for this example
    mount Parse::Webhooks, :at => '/webhooks'
end
