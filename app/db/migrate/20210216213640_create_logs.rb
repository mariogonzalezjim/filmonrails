class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.string :email_user
      t.string :id_film

      t.timestamps
    end
  end
end
