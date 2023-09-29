module UserBonuses
  class Fetcher
    class << self
      delegate :execute, to: :new
    end

    def execute(account_id:, type_id:, page:, limit:)
      fetch_result = BonusService::Loyal.fetch_bonuses(account_id: account_id)
      return fetch_result unless fetch_result.success?

      converted_result = Converter.execute(fetch_result.data[:bonuses], type_id, page, limit)

      Result.ok(data: { bonuses: converted_result.data[:bonuses], total_count: converted_result.data[:total_count] })
    rescue StandardError => _error
      Result.error(http_code: 500)
    end
  end
end
