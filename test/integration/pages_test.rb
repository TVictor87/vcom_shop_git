require 'test_helper'

def test_page(url, checked)
  checked << url
  p "Getting #{url}"
  get url
  assert_response :success
  Nokogiri::HTML(response.body).css('a')
    .map { |a| a['href'] }
    .find_all { |u| !checked.include? u }
    .each { |u| test_page u, checked }
end

class PagesTest < ActionDispatch::IntegrationTest
  test 'Все страницы отвечают со статусом 200' do
    test_page '/', ['', '#']
  end
end
