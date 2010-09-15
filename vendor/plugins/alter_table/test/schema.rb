ActiveRecord::Schema.define(:version => 0) do
  create_table :people, :force => true do |t|
    t.string :first_name, :null => false, :default => 'John'
  end
end
