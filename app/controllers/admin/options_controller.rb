module Admin
  class OptionsController < BaseController
    before_action :set_option, only: [:show, :edit, :update, :destroy]

    def index
      @options = Option.all
    end

    def new
      @option = Option.new
    end

    def create
      p = option_params
      option_group_id = p[:option_group_id]
      color = false
      if option_group_id
        group = OptionGroup.select(:field_type).find(option_group_id)
        if group and group.field_type == 'color'
          color = true
          p[:value_ru] = 'ffffff' + p[:value_ru]
          p[:value_uk] = 'ffffff' + p[:value_uk]
          p[:value_en] = 'ffffff' + p[:value_en]
        end
      end
      option = Option.create(p)
      if option.valid?
        if color
          redirect_to edit_admin_option_path(option.id), notice: t('options.create.success')
        else
          redirect_to admin_options_path, notice: t('options.create.success')
        end
      else
        redirect_to new_admin_options_path, alert: option.errors.messages
      end
    end

    def destroy
      @option.destroy
      redirect_to admin_options_path, notice: t('options.destroy.success')
    end

    def show
    end

    def edit
    end

    def update
      p = option_params
      hex = params[:hex]
      if hex
        p[:value_ru] = hex + p[:value_ru]
        p[:value_uk] = hex + p[:value_uk]
        p[:value_en] = hex + p[:value_en]
      end
      if @option.try(:update, p)
        redirect_to admin_options_path, notice: t('admin.update.success')
      else
        redirect_to edit_options_path(@option.id), alert: @option.errors.messages
      end
    end

    private

    def option_params
      params.require(:option).permit(:option_group_id, :value_ru, :value_uk, :value_en, :column, :retail_price, :retail_price_currency_id, :priority)
    end

    def set_option
      @option = Option.find(params[:id])
    end
  end
end