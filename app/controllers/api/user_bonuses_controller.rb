module Api
  class UserBonusesController < ApplicationController
    include Accessible

    # GET /bonuses
    # identified only
    def index
      if user_bonuses_fetch.success?
        fetch_data = user_bonuses_fetch.data

        render json: {
          total_count: fetch_data[:total_count],
          limit: params[:limit].to_i,
          data: fetch_data[:bonuses]
        }.to_json, status: :ok
      else
        respond_error(user_bonuses_fetch)
      end
    end

    # GET /bonuses_types
    # both anonymous and identified - doesn't impact the response
    def bonuses_types
      render json: { data: UserBonuses::Types::LIST }.to_json, status: :ok
    end

    private

    def permitted_params
      params.permit(:type_id, :page, :limit)
    end

    def user_bonuses_fetch
      @user_bonuses_fetch ||= UserBonuses::Fetcher.execute(
        account_id: user.profile.uid,
        type_id: permitted_params[:type_id].to_i,
        page: permitted_params[:page].to_i,
        limit: permitted_params[:limit].to_i
      )
    end
  end
end
