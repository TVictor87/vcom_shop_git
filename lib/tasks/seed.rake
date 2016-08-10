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

def category3
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

def warehouses
  Warehouse.delete_all
  Warehouse.create name: 'Главный склад'  
  Warehouse.create name: 'Второй склад'  
  Warehouse.create name: 'Третий склад'  
end

def option_groups
  OptionGroup.delete_all

  category_ids = [Category.select(:id).fourth.id]

  OptionGroup.create(
    category_ids: category_ids,
    title_ru: 'Бренды',
    title_uk: 'Бренды',
    title_en: 'Бренды',
    field_type: 'string'
  )

  OptionGroup.create(
    category_ids: category_ids,
    title_ru: 'Состав',
    title_uk: 'Состав',
    title_en: 'Состав',
    field_type: 'string',
    priority: 2,
    visible: false
  )

  OptionGroup.create(
    category_ids: category_ids,
    title_ru: 'Плотность',
    title_uk: 'Плотность',
    title_en: 'Плотность',
    field_type: 'string',
    priority: 3
  )

  OptionGroup.create(
    category_ids: category_ids,
    title_ru: 'Категории',
    title_uk: 'Категории',
    title_en: 'Категории',
    field_type: 'string',
    priority: 5
  )

  OptionGroup.create(
    category_ids: category_ids,
    title_ru: 'Цвет',
    title_uk: 'Цвет',
    title_en: 'Цвет',
    field_type: 'color',
    priority: 1,
    active: true
  )

  OptionGroup.create(
    category_ids: category_ids,
    title_ru: 'Размер',
    title_uk: 'Размер',
    title_en: 'Размер',
    field_type: 'string',
    columns: 3,
    priority: 4,
    active: true
  )
end

def random_ids all
  rand(1..all.size).times.map{all.sample}.uniq
end

def options
  Option.delete_all

  product_ids = Product.pluck :id

  option_group_id = OptionGroup.select(:id).find_by_title_ru('Бренды').id
  %W(Ballerina Charmante Falke Filodoro Gatta Giulietta Glamour Golden Lady Innamore Jadea LORA GRIG Marilyn MiNiMi Omsa).each_with_index do |value, index|
    Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      product_ids: (index == 15 and product_ids[90..100] or product_ids[(index * 6)..((index + 1) * 6 - 1)])
    )
  end
  
  option_group_id = OptionGroup.select(:id).find_by_title_ru('Состав').id
  %W(Нейлон Полиамид Хлопок Шерсть).each_with_index do |value, index|
    Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      product_ids: random_ids(product_ids)
    )
  end
  
  option_group_id = OptionGroup.select(:id).find_by_title_ru('Плотность').id
  ['05 - 15 den', '20 - 40 den', '50 - 100 den', 'Больше 100 den'].each_with_index do |value, index|
    Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      product_ids: random_ids(product_ids)
    )
  end
  
  option_group_id = OptionGroup.select(:id).find_by_title_ru('Категории').id
  ['Бесшовные', 'Имитация чулков', 'Имитация ботфорт', 'Корректирующие', 'Без шортиков', 'Для берменных', 'С шортиками', 'Низкая талия', 'На свадьбу', 'С трусиками', 'Большие размеры', 'С открытыми пальчиками', 'Сеточка'].each_with_index do |value, index|
    Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      product_ids: random_ids(product_ids)
    )
  end

  option_group_id = OptionGroup.select(:id).find_by_title_ru('Цвет').id
  color_ids = []
  %W(ffffffбелый fdf3aeжёлтый f0dfd0кремовый d21d17красный c99967телесный ccb9a5бежевый c55124оранжевый bd90c7лаванда b78a73бежевый af2e94сиреневый aed7aaмятный a68668бежевый 930000красный 8f6d52бежевый 848484серый 59351dкоричневый 39728cголубой 0b363eсиний 000000чёрный).each_with_index do |value, index|
    color_ids << Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index
    ).id
  end
  
  option_group_id = OptionGroup.select(:id).find_by_title_ru('Размер').id
  size_ids = []
  %W(XS S S/M M ML L XL 2XL 3XL 4XL).each_with_index do |value, index|
    size_ids << Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      column: 1
    ).id
  end
  %W(T1 T2 T3 T4 T5 T6).each_with_index do |value, index|
    size_ids << Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      column: 2
    ).id
  end
  ['One Size', '1', '2', '3', '4', '5'].each_with_index do |value, index|
    size_ids << Option.create(
      option_group_id: option_group_id,
      value_ru: value,
      value_uk: value,
      value_en: value,
      priority: index,
      column: 3
    ).id
  end

  warehouse_ids = Warehouse.pluck(:id)
  product_ids.each do |product_id|
    random_size_ids = random_ids random_ids(size_ids)
    random_color_ids = random_ids random_ids(color_ids)
    warehouse_ids.each do |warehouse_id|
      random_ids(random_size_ids).each do |size_id|
        random_ids(random_color_ids).each do |color_id|
          WarehouseProduct.create(
            warehouse_id: warehouse_id,
            product_id: product_id,
            quantity: rand(0..20),
            retail_price_changed: rand(0..100),
            option_ids: [size_id, color_id]
          )
        end
      end
    end
    Product.update(product_id, {
      option_ids: Option.joins(:products).where(options_products: {product_id: product_id}).pluck(:id) + random_size_ids + random_color_ids
    })
  end
end

def products
  category_id, currencies = products_start
  i = 0
  Product.populate 100 do |product|
    i += 1
    product_set product, i, category_id, currencies
  end

  Product.all.each do |product|
    Random.rand(1..3).times { product_create_image product }
  end
end

namespace :seed do
  task categories: :environment do
    categories
  end

  task products: :environment do
    products
  end

  task option_groups: :environment do
    option_groups
  end

  task options: :environment do
    options
  end

  task all: :environment do
    categories
    products
    warehouses
    option_groups
    options
  end
end