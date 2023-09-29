module UserBonuses
  class Paginator
    class << self
      delegate :execute, to: :new
    end

    def execute(bonuses, page, limit)
      if page == 1
        bonuses[0..(limit - 1)]
      else
        bonuses[(page * limit - limit)..(page * limit - 1)]
      end
    end
  end
end
