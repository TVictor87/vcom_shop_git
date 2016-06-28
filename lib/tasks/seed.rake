require 'populator'
require 'faker'

namespace :seed do
  desc 'Create admin user'
  task users: :environment do
    User.delete_all
    User.create(email: 'admin@gmail.com', password: '1q2w3e4r', first_name: 'Admin', last_name: 'Admin', role: 'admin')
  end

  desc 'Create base sites'
  task sites: :environment do
    Site.delete_all

    Site.create(title_ru: 'Vkolgotkah.com', title_uk: 'Vkolgotkah.com', title_en: 'Vkolgotkah.com', constant_name: 'Vkolgotkah')
    Site.create(title_ru: 'Панчохи.укр', title_uk: 'Панчохи.укр', title_en: 'Панчохи.укр', constant_name: 'Panchohy')
  end

  task currencies: :environment do
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
  end

  task categories: :environment do
    Category.delete_all

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

    category = Category.new(
      url_ru: 'kolgotki',
      url_en: 'tights',
      url_uk: 'panchohy',
      name_ru: 'Колготки',
      name_en: 'Tights',
      name_uk: 'Панчохи',
      category: women
    )
    category.image = Rails.root.join("public/images/img0#{rand(5) + 1}.jpg").open
    category.save
  end

  task products: :environment do
    Product.delete_all
    Image.delete_all

    category_id = Category.last.id

    currencies = Currency.pluck :id

    i = 0
    Product.populate 100 do |product|
      product.title_ru = Faker::Commerce.product_name
      product.url_ru = "product-#{i += 1}"
      product.description_ru = Faker::Lorem.sentences(3)
      product.retail_price = Faker::Commerce.price
      product.priority = rand(100)
      product.category_id = category_id
      product.active = true
      product.retail_price_currency_id = currencies.sample
    end

    Product.all.each do |product|
      product.images.create(
        image: Rails.root.join("public/images/img0#{rand(5) + 1}.jpg").open,
        title_ru: 'title_r',
        alt_ru: 'alt_ru'
      )
    end
  end
end
