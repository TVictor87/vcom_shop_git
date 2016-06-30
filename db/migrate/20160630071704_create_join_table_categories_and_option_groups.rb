class CreateJoinTableCategoriesAndOptionGroups < ActiveRecord::Migration
  def change
    create_join_table :categories, :option_groups do |t|
      t.index [:category_id, :option_group_id], name: 'c_og_index'
      t.index [:option_group_id, :category_id], name: 'og_c_index'
    end
  end
end
