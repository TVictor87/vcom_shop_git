module Admin
  class OptionsGroupsController < BaseController
    before_action :set_option_group, only: [:show, :edit, :update, :destroy]

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
      @options_group.destroy
      redirect_to admin_options_groups_path, notice: t('options_groups.destroy.success')
    end

    def show
    end

    def edit
    end

    def update
      if @options_group.try(:update, options_group_params)
        redirect_to admin_options_groups_path, notice: t('admin.update.success')
      else
        redirect_to edit_options_groups_path(@options_group.id), alert: @options_group.errors.messages
      end
    end

    private

    def options_group_params
      params.require(:options_group).permit(:title_uk, :title_en, :title_ru, :constant_name)
    end

    def set_option_group
      @option = OptionsGroup.find(params[:id])
    end
  end
end
