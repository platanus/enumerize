require 'test_helper'
require 'active_record'
require 'logger'

silence_warnings do
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Base.logger = Logger.new(nil)
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
end

ActiveRecord::Base.connection.instance_eval do
  create_table :clients do |t|
    t.string :sex
    t.string :name
  end
end

class Client < ActiveRecord::Base
  extend Enumerize
  enumerize :sex, :in => [:male, :female]
end

describe 'Ransack support' do

  describe 'Formtastic' do

    it 'renders select with enumerized values' do
      client = Client.search({})
      puts client.inspect

      concat(semantic_form_for(client) do |f|
        f.input :sex
      end)

      assert_select 'select option[value=male]'
      assert_select 'select option[value=female]'
    end

  end

end