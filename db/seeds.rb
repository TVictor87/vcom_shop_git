# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO: Create base pages: Main page with description
# TODO: Create base pages: Wholesale_customers, Bestsellers, Sale

User.delete_all
User.create(email: 'admin@gmail.com', password: '1q2w3e4r', first_name: 'Admin', last_name: 'Admin', role: 'admin')

Site.delete_all
Site.create(title_ru: 'Vkolgotkah.com', title_uk: 'Vkolgotkah.com', title_en: 'Vkolgotkah.com', constant_name: 'Vkolgotkah')
Site.create(title_ru: 'Панчохи.укр', title_uk: 'Панчохи.укр', title_en: 'Панчохи.укр', constant_name: 'Panchohy')

Currency.delete_all

Currency.create(
  value: 1,
  title_ru: 'Грн',
  title_uk: 'Грн',
  title_en: 'UAH',
  constant_name: 'UAH'
)

Currency.create(
  value: 25,
  title_ru: 'Дол',
  title_uk: 'Дол',
  title_en: 'USD',
  constant_name: 'USD'
)

Page.create(
  constant_name: 'MAIN_PAGE'
)
