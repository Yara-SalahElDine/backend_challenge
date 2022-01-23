class ApplicationController < ActionController::API

  protected

    def empty_param(param)
      render json:{error: "#{param}_param_is_empty", status: 422}, status: 422
    end

    def object_not_found(object)
      render json:{ error: "#{object}_not_found", status: 404 }, status: 404
    end

end
