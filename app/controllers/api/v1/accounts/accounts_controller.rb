# frozen_string_literal: true

class Api::V1::Accounts::AccountsController < Api::V1::InternalController
  before_action :set_account, only: %i[show update]

  def show
    if @account
      render json: @account, status: :ok
    else
      render json: { errors: 'Not found' }, status: :not_found
    end
  end

  def update
    if @account.update(account_params)
      render json: @account, status: :ok
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = Account.find(params['id'])
  end

  def account_params
    params.permit(:name, :number_of_employees, :segment, :site_url, :woofbot_auto_reply)
  end
end
