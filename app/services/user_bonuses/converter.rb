module UserBonuses
  class Converter
    class << self
      delegate :execute, to: :new
    end

    def execute(bonuses, type_id, page, limit)
      bonuses = bonuses&.reverse

      # we should calculate the amounts before excluding the elements by filters or paginator
      amounts = Summator.amounts_by_months(bonuses)
      # filter elements by type_id, rejecting all others
      filtered_bonuses = Filter.by_type(bonuses, type_id)
      total_count = filtered_bonuses&.count
      # paginate filtered elements by page & limit from params
      paginated_bonuses = Paginator.execute(filtered_bonuses, page, limit)
      # group paginated elements by months
      grouped_bonuses = Filter.group_by_months(paginated_bonuses)
      # rework response data
      modified_bonuses = Modifier.rework_batch(grouped_bonuses, amounts)

      Result.ok(data: { bonuses: modified_bonuses, total_count: total_count })
    rescue StandardError => _error
      Result.error
    end
  end
end
