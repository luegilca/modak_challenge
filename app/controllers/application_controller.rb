class ApplicationController < ActionController::API
  
  rescue_from 'ActionController::ParameterMissing' do |exception|
    misformatted_input(error: exception)
  end

end
