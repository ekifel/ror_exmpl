module UserBonuses
  class Summator
    class << self
      delegate :amounts_by_months, to: :new
    end

    def amounts_by_months(bonuses)
      amounts = {}

      bonuses.each do |item|
        date = Date.parse(item['date']).beginning_of_month
        amounts[date] = 0 unless amounts.key?(date)

        amounts[date] += item['amount'] if item['amount']&.positive?
      end

      amounts
    end
  end
end
