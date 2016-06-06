module Admin
  class OptionsGroupsController < BaseController
    def index
      @options_groups = OptionsGroup.all
    end

    def new
      @options_group = OptionsGroup.new
    end

    def create
      options_group = OptionsGroup.create(options_group_params)
      if options_group.valid?
        redirect_to admin_options_groups_path, notice: t('options_groups.create.success')
      else
        redirect_to new_admin_options_groups_path, alert: options_group.errors.messages
      end
    end

    def destroy
      @options_group = OptionsGroup.find(params[:id])
      @options_group.destroy
      redirect_to admin_options_groups_path, notice: t('options_groups.destroy.success')
    end

    def show
      @options_group = OptionsGroup.find(params[:id])
    end

    def edit
      @options_group = OptionsGroup.find(params[:id])
    end

    def update
      options_group = OptionsGroup.find(params[:id])

      if options_group.try(:update, options_group_params)
        redirect_to admin_options_groups_path, notice: t('admin.update.success')
      else
        redirect_to edit_options_groups_path(options_groups.id), alert: options_groups.errors.messages
      end
    end

    private

    def options_group_params
      params.require(:options_group).permit(:title_uk, :title_en, :title_ru, :constant_name)
    end
  end
end
