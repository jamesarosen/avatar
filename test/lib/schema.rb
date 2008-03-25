ActiveRecord::Schema.define :version => 0 do
  create_table :users, :force => true do |t|
    t.column :name,  :text, :nil => false
    t.column :email, :text, :nil => false
    t.column :avatar, :string
  end
end