ActiveRecord::Schema.define(:version => 0) do

  create_table "articles", :force => true do |t|
    t.string "title", "body"
  end

end
