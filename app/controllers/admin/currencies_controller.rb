module Admin
  class CurrenciesController < Admin::BaseController
    before_action :set_currency, only: [:show, :edit, :update, :destroy]

    # GET /pages
    def index
      @currencies = Currency.all
    end

    # GET /pages/1
    def show
    end

    # GET /pages/new
    def new
      @currency = Currency.new
    end

    # GET /pages/1/edit
    def edit
    end

    # POST /pages
    def create
      @currency = Currency.create(currency_params)

      if @currency.valid?
        redirect_to admin_currencies_path, notice: t('admin.create.success')
      else
        redirect_to admin_currencies_path, alert: @currency.errors.messages
      end
    end

    # PATCH/PUT /pages/1
    def update
      if @currency.try(:update, currency_params)
        redirect_to admin_currencies_path, notice: t('admin.update.success')
      else
        redirect_to edit_admin_currency_path(@currency.id), alert: @currency.errors.messages
      end
    end

    # DELETE /pages/1
    def destroy
      @currency.destroy
      redirect_to admin_currencies_url, notice: t('admin.destroy.success')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Never trust parameters from the internet, only allow the white list through.
    def currency_params
      params.require(:currency).permit(
        :title_ru,
        :title_uk,
        :title_en,
        :value,
        :constant_name
      )
    end
  end
end