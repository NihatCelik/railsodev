class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :baslik
      t.text :icerik

      t.timestamps null: false
    end
  end
end
