module BonusService
  class Loyal
    class ClientBonuses < Base
      PATH = 'client_bonuses'.freeze
      MAX_NUMBER_OF_RECORDS = 100

      class << self
        delegate :fetch, to: :new
      end

      def fetch(account_id:)
        response = resource(path, query_params: fetch_params(account_id)).get

        Result.ok(data: { bonuses: parse_fetch_response(response) })
      rescue RestClient::Exception => error
        handle_error(error)
      end

      private

      def parse_fetch_response(response)
        JSON.parse(response.body)['data']
      end

      def path
        "#{BASE_PATH}/#{PATH}"
      end

      def fetch_params(account_id)
        {
          'UID' => account_id,
          'records' => MAX_NUMBER_OF_RECORDS
        }
      end
    end
  end
end
