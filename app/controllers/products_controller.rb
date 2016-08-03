class ProductsController < PagesController
  before_action :set_product

  def show
    rend 'products/show'
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
    @category = Category.find_by(params[:column] => params[:category_url], id: @product.category_id)
    @parent = @category.category
    @groups = {}
    ActiveRecord::Base.connection.select_rows(
      "SELECT og.id, og.title_#{locale}, o.id, o.value_#{locale}, wp.id "\
      "FROM warehouse_products wp "\
      "INNER JOIN options_warehouse_products owp ON owp.warehouse_product_id = wp.id "\
      "INNER JOIN options o ON o.id = owp.option_id "\
      "INNER JOIN option_groups og ON og.id = o.option_group_id "\
      "WHERE wp.product_id = #{@product.id} ORDER BY og.priority"
    ).each{|row|
      group_id = row[0]
      if @groups[group_id] == nil
        @groups[group_id] = {title: row[1], options: {}}
      end
    }
  end

end