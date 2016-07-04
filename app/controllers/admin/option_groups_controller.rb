module Admin
  class OptionGroupsController < BaseController
    before_action :set_option_group, only: [:show, :edit, :update, :destroy]

    def index
      @option_groups = OptionGroup.all
    end

    def new
      @option_group = OptionGroup.new
    end

    def create
      option_group = OptionGroup.create(option_group_params)
      if option_group.valid?
        redirect_to admin_option_groups_path, notice: t('option_groups.create.success')
      else
        redirect_to new_admin_option_groups_path, alert: option_group.errors.messages
      end
    end

    def destroy
      @option_group.destroy
      redirect_to admin_option_groups_path, notice: t('option_groups.destroy.success')
    end

    def show
    end

    def edit
    end

    def update
      if @option_group.try(:update, option_group_params)
        redirect_to admin_option_groups_path, notice: t('admin.update.success')
      else
        redirect_to edit_option_groups_path(@option_group.id), alert: @option_group.errors.messages
      end
    end

    private

    def option_group_params
      params.require(:option_group).permit(:title_uk, :title_en, :title_ru, :field_type, :required, :active)
    end

    def set_option_group
      @option_group = OptionGroup.find(params[:id])
    end
  end
end
