require 'test_helper'

$course = Currency.select(:value).take.value

class ProductTest < ActiveSupport::TestCase
	test "default_scope" do
		products = Product.all.to_a
		assert_nil products.find{ |p| !p.active }
		assert_not products.last.priority.to_i < products.first.priority.to_i
	end

	test "min_price" do
		products = Product.join_price
		assert_equal products.select("retail_price * value as retail_price").map(&:retail_price).sort.first.floor, products.min
	end

	test "max_price" do
		products = Product.join_price
		assert_equal products.select("retail_price * value as retail_price").map(&:retail_price).sort.last.ceil, products.max
	end

	test "select_few" do
		p = Product.join_price.select_few.take
		assert p.respond_to? :id
		assert p.respond_to? :retail_price
		assert p.respond_to? "title_#{I18n.locale}"
	end

	test "price_from" do
		assert Product.join_price.price_from(100500).empty?
	end

	test "price_to" do
		assert Product.join_price.price_to(0).empty?
	end

	test "locale_title" do
		p = Product.take
		assert_equal p.title_ru, p.title
	end

	test "price" do
		Product.take.price.include? "грн"
	end
end
