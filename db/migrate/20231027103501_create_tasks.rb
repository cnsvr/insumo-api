# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title, null: false
      t.datetime :due_date, null: false, index: true
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: true

      t.timestamps
    end
  end
end
