module JsonResponse
  def general_success(message)
    render json: {
      data: {
        message: message
      }
    }, status: :ok
  end

  def general_error(errors)
    render json: {
      data: {
        errors: errors
      }
    }, status: :internal_server_error
  end

  def misformatted_input(error: )
    render json: {
      data: {
        errors: [
          "There are some required fields that are not present!",
          error
        ]  
      }
    }, status: :bad_request
  end
end