# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO: Create base pages: Main page with description
# TODO: Create base pages: Wholesale_customers, Bestsellers, Sale

require 'populator'
require 'faker'

User.delete_all
Site.delete_all
Category.delete_all
Product.delete_all
Image.delete_all

# Create admin user
User.create(email: 'admin@gmail.com', password: '1q2w3e4r', first_name: 'Admin', last_name: 'Admin', role: 'admin')

# Create base sites
Site.create(title_ru: 'Vkolgotkah.com', title_uk: 'Vkolgotkah.com', title_en: 'Vkolgotkah.com', constant_name: 'Vkolgotkah')
Site.create(title_ru: 'Панчохи.укр', title_uk: 'Панчохи.укр', title_en: 'Панчохи.укр', constant_name: 'Panchohy')


women = Category.create(
	url_ru: 'zhenshchinam',
	url_en: 'women',
	url_uk: 'zhinkam',
	name_ru: 'Для женщин',
	name_en: 'For women',
	name_uk: 'Для жінок'
)
Category.create(
	url_ru: 'muzhchinam',
	url_en: 'men',
	url_uk: 'cholovikam',
	name_ru: 'Для мужчин',
	name_en: 'For men',
	name_uk: 'Для чоловіків'
)
Category.create(
	url_ru: 'detyam',
	url_en: 'child',
	url_uk: 'dityam',
	name_ru: 'Для детей',
	name_en: 'For child',
	name_uk: 'Для дітей'
)

category_id = Category.create(
	url_ru: 'kolgotki',
	url_en: 'tights',
	url_uk: 'panchohy',
	name_ru: 'Колготки',
	name_en: 'Tights',
	name_uk: 'Панчохи',
	category: women
).id

Product.populate 100 do |product, i|
	product.title_ru = Faker::Commerce.product_name
	product.url_ru = "product-#{i}"
	product.description_ru = Faker::Lorem.sentences(3)
	product.retail_price = Faker::Commerce.price
	product.priority = rand(100)
	product.category_id = category_id
	product.active = true
end

Product.all.each do |product|
	product.images.create(
		image: Rails.root.join("public/images/img0#{rand(5) + 1}.jpg").open,
		title_ru: "title_ru",
		alt_ru: "alt_ru"
	)
end