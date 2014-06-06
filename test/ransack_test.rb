require 'test_helper'
require 'active_record'
require 'logger'
require 'ransack'
require 'formtastic'
require 'simple_form'
load './lib/enumerize.rb'

silence_warnings do
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Base.logger = Logger.new(nil)
  if !ActiveRecord::Base.connected?
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
  end
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

class RansackSpec < MiniTest::Spec
  include ViewTestHelper
  include Formtastic::Helpers::FormHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  it 'renders select with enumerized values for formtastic' do
    client = Client.search({})

    concat(semantic_form_for(client) do |f|
      f.input :sex
    end)

    assert_select 'select option[value=male]'
    assert_select 'select option[value=female]'
  end

  it 'renders select with enumerized values for simple form' do
    client = Client.search({})

    concat(simple_form_for(client) do |f|
      f.input :sex
    end)

    assert_select 'select option[value=male]'
    assert_select 'select option[value=female]'
  end

end
