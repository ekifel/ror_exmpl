module UserBonuses
  class Modifier
    class << self
      delegate :rework_batch, to: :new
    end

    def rework_batch(bonuses, amounts)
      bonuses.map do |month, objects|
        {
          month: DateTime.parse(month.to_s).to_i,
          amount: amounts[month]&.round(2).to_s,
          data: objects.map { |obj| rework_fields(obj.with_indifferent_access) }
        }
      end
    end

    private

    def rework_fields(bonus)
      bonus = modified_bonus(bonus)
      remove_unnecessary_fields(bonus)
    end

    def modified_bonus(bonus)
      store_id = bonus[:store]

      bonus.merge(
        purchase_id: bonus[:id],
        date: DateTime.parse(bonus[:date]).to_i,
        shop_address: shop_address(store_id),
        check_number: check_number(bonus[:source], store_id),
        bonus: bonus[:amount].abs.to_s,
        is_authorization_bonus: false,
        is_referral_bonus: false,
        receipt_id: bonus[:source_id],
        shop_id: store_id
      )
    end

    def shop_address(store_id)
      Shop.find_by(store_id: store_id)&.address
    end

    def check_number(ch_num, shop_id)
      if shop_id.present?
        "#{shop_id}.#{ch_num&.gsub(/[^\d.]/, '')}"
      else
        ''
      end
    end

    def remove_unnecessary_fields(bonus)
      fields = %w[id uid amount opdate source_id store store_name source chequesum balance commentary]

      bonus.except(*fields)
    end
  end
end
