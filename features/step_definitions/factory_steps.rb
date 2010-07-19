def parse_attrs_table(table)
  attrs = {}
  table.raw.each do |(attr, value)|
    sanitized_attr = attr.gsub(/\s+/,"-").underscore
    attrs[sanitized_attr.to_sym] = value
  end
  attrs
end

Factory.factories.each do |name, factory|
  Given /^an? #{name} exists with the following attributes:$/ do |attrs_table|
    attrs = parse_attrs_table(attrs_table)
    variable = "@#{name}"
    eval("#{variable} = Factory(name, attrs)")
  end
  Given /^a new #{name} exists with the following attributes:$/ do |attrs_table|
    attrs = parse_attrs_table(attrs_table)
    variable = "@#{name}"
    eval("#{variable} = Factory.build(name, attrs)")
  end
end