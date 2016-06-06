# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create admin user
User.create(email: 'admin@gmail.com', password: '1q2w3e4r', first_name: 'Admin', last_name: 'Admin', role: 'admin')

# Create base sites
Site.create(title_ru: 'Vkolgotkah.com', title_uk: 'Vkolgotkah.com', title_en: 'Vkolgotkah.com', constant_name: 'Vkolgotkah')
Site.create(title_ru: 'Панчохи.укр', title_uk: 'Панчохи.укр', title_en: 'Панчохи.укр', constant_name: 'Panchohy')

# TODO: Create base pages: Main page with description
# TODO: Create base pages: For Mans, For womans, For Children
# TODO: Create base pages: Wholesale_customers, Bestsellers, Sale
# TODO: Create base pages: Catalog
