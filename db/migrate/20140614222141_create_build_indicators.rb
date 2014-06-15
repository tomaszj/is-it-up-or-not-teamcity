class CreateBuildIndicators < ActiveRecord::Migration
  def change
    create_table :build_indicators do |t|
      t.string :name
      t.string :build_types
    end
  end
end
