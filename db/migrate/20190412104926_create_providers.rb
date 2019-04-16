class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :provider
      t.string :uid
      t.belongs_to :user

      t.timestamps
    end
  end
end
