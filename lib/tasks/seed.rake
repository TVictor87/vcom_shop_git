require 'populator'
require 'faker'

def category1
  Category.create(
    url_ru: 'zhenshchinam',
    url_en: 'women',
    url_uk: 'zhinkam',
    name_ru: 'Для женщин',
    name_en: 'For women',
    name_uk: 'Для жінок'
  )
end

def category2
  Category.create(
    url_ru: 'muzhchinam',
    url_en: 'men',
    url_uk: 'cholovikam',
    name_ru: 'Для мужчин',
    name_en: 'For men',
    name_uk: 'Для чоловіків'
  )
end

def category2
  Category.create(
    url_ru: 'detyam',
    url_en: 'child',
    url_uk: 'dityam',
    name_ru: 'Для детей',
    name_en: 'For child',
    name_uk: 'Для дітей'
  )
end

def category4(women)
  Category.create(
    url_ru: 'kolgotki',
    url_en: 'tights',
    url_uk: 'panchohy',
    name_ru: 'Колготки',
    name_en: 'Tights',
    name_uk: 'Панчохи',
    category: women
  )
end

def categories
  Category.delete_all

  women = category1
  category2
  category3
  category = category4 women
  category.image = Rails.root.join("public/images/img0#{rand(5) + 1}.jpg").open
  category.save
end

def products_start
  Product.delete_all
  Image.delete_all
  [Category.last.id, Currency.pluck(:id)]
end

def half_product(product, i)
  product.title_ru = Faker::Commerce.product_name
  product.url_ru = "product-#{i}"
  product.description_ru = Faker::Lorem.sentences(3)
  product.retail_price = Faker::Commerce.price
end

def product_set(product, i, category_id, currencies)
  half_product product, i
  product.priority = rand(100)
  product.category_id = category_id
  product.active = true
  product.retail_price_currency_id = currencies.sample
end

def product_create_image(product)
  product.images.create(
    image: Rails.root.join("public/images/img0#{rand(5) + 1}.jpg").open,
    title_ru: 'title_r',
    alt_ru: 'alt_ru'
  )
end

def products
  category_id, currencies = products_start
  i = 0
  Product.populate 100 do |product|
    i += 1
    product_set product, i, category_id, currencies
  end

  Product.all.each do |product|
    product_create_image product
  end
end

namespace :seed do
  task categories: :environment do
    categories
  end

  task products: :environment do
    products
  end

  task all: :environment do
    categories
    products
  end
end
