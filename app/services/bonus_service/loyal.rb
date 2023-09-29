module BonusService
  class Loyal < Base
    class << self
      def fetch_bonuses(account_id:)
        ClientBonuses.fetch(account_id: account_id)
      end
    end
  end
end
