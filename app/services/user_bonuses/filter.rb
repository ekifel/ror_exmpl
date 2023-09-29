module UserBonuses
  class Filter
    TYPES = {
      1 => { type_alias: 'Accural', type_title: 'Начисления' },
      2 => { type_alias: 'WriteOff', type_title: 'Списания' }
    }.freeze

    class << self
      delegate :by_type, to: :new
      delegate :group_by_months, to: :new
    end

    def by_type(bonuses, type_id)
      bonuses&.select do |bonus|
        check_bonus_type(bonus, type_id)
      end
    end

    def group_by_months(bonuses)
      bonuses&.group_by do |item|
        Date.parse(item['date']).beginning_of_month
      end
    end

    private

    def check_bonus_type(bonus, type_id)
      bonus_type = bonus['amount']&.positive? ? 1 : 2
      if type_id.zero? || type_id == bonus_type
        add_bonus_info(bonus, bonus_type)

        return true
      end

      false
    end

    def add_bonus_info(bonus, type_id)
      bonus['type_id'] = type_id
      bonus['type_alias'] = TYPES.dig(type_id, :type_alias)
      bonus['type_title'] = TYPES.dig(type_id, :type_title)
    end
  end
end
