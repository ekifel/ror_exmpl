module BonusService
  class Base
    private

    def resource(path, query_params: {})
      RestClient::Resource.new(
        compose_url(path: path, query_params: query_params),
        user: ENV['bonus_service_login'],
        password: ENV['bonus_service_password'],
        verify_ssl: false
      )
    end

    def compose_url(path:, query_params: {})
      [
        ENV['bonus_service_base_url'],
        '/', path,
        '?', query_params.to_query
      ].join
    end

    def handle_error(error)
      return Result.error(message: JSON.parse(error.response.body), http_code: error.http_code) if error&.http_code

      # server errors
      raise BonusServiceException, error.message
    end
  end
end
