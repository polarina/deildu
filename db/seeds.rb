# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.find_or_initialize_by_id(1).update_attributes!(:id => 1, :title => "DVD-R")
Category.find_or_initialize_by_id(2).update_attributes!(:id => 2, :title => "Annað")
Category.find_or_initialize_by_id(3).update_attributes!(:id => 3, :title => "High Definition")
Category.find_or_initialize_by_id(4).update_attributes!(:id => 4, :title => "Leikir")
Category.find_or_initialize_by_id(5).update_attributes!(:id => 5, :title => "Þættir")

Status.find_or_initialize_by_id(1).update_attributes!(:id => 1, :status => "Opið")
Status.find_or_initialize_by_id(2).update_attributes!(:id => 2, :status => "Lokað")
