module Admin
  class OptionsController < BaseController
    def index
      @options = Option.all
    end

    def new
      @option = Option.new
    end

    def create
      option = Option.create(option_params)
      if option.valid?
        redirect_to admin_options_path, notice: t('options.create.success')
      else
        redirect_to new_admin_options_path, alert: option.errors.messages
      end
    end

    def destroy
      @option = Option.find(params[:id])
      @option.destroy
      redirect_to admin_options_path, notice: t('options.destroy.success')
    end

    def show
      @option = Option.find(params[:id])
    end

    def edit
      @option = Option.find(params[:id])
    end

    def update
      option = Option.find(params[:id])
      if option.try(:update, option_params)
        redirect_to admin_options_path, notice: t('admin.update.success')
      else
        redirect_to edit_options_path(options.id), alert: options.errors.messages
      end
    end

    private

    def option_params
      params.require(:option).permit(:options_group_id, :title_uk, :title_en, :title_ru, :field_type, :required, :is_active, :priority)
    end
  end
end
