module I18nable
  [:text, :name, :url, :title, :description, :alt, :value].each do |method_name|
    define_method(method_name){ (self["#{method_name}_#{I18n.locale}"] || send("#{method_name}_ru")) rescue nil }
  end
end