module Admin
  class WarehousesController < Admin::BaseController
    before_action :set_warehouse, only: [:edit, :update, :destroy]

    # GET /warehouses
    def index
      @warehouses = Warehouse.all
    end

    # GET /warehouses/new
    def new
      @warehouse = Warehouse.new
    end

    # GET /warehouses/1/edit
    def edit
    end

    # POST /warehouses
    def create
      @warehouse = Warehouse.create(warehouse_params)

      if @warehouse.valid?
        redirect_to admin_warehouses_path, notice: t('admin.create.success')
      else
        redirect_to admin_warehouses_path, alert: @warehouse.errors.messages
      end
    end

    # PATCH/PUT /warehouses/1
    def update
      if @warehouse.try(:update, warehouse_params)
        redirect_to admin_warehouses_path, notice: t('admin.update.success')
      else
        redirect_to edit_admin_warehouse_path(@warehouse.id), alert: @warehouse.errors.messages
      end
    end

    # DELETE /warehouses/1
    # DELETE /warehouses/1.json
    def destroy
      @warehouse.destroy
      redirect_to admin_warehouses_url, notice: t('admin.destroy.success')
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Never trust parameters from the internet, only allow the white list through.
    def warehouse_params
      params.require(:warehouse).permit(:name)
    end
  end
end
