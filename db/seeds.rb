# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
User.create(:email => 'ian@gimmebutter.com', :password => 'password', :password_confirmation => 'password', :admin => true)
User.create(:email => 'maloney.mc@gmail.com', :password => 'password', :password_confirmation => 'password', :admin => true)
