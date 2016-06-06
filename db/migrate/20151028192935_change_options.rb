class ChangeOptions < ActiveRecord::Migration
  def change
    change_column_default :options, :required, true
    change_column_default :options, :is_active, true
  end
end
