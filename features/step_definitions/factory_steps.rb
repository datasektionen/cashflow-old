def parse_attrs_table(table)
  attrs = {}
  table.raw.each do |(attr, value)|
    sanitized_attr = attr.gsub(/\s+/, '-').underscore
    attrs[sanitized_attr.to_sym] = value
  end
  attrs
end

FactoryGirl.factories.each do |factory|
  name = factory.name
  Given(/^an? #{name} exists? with the following attributes:$/i) do |table|
    attrs = parse_attrs_table(table)
    variable = "@#{name}"
    eval("#{variable} = create(name, attrs)")
  end
  Given(/^a new #{name} exists? with the following attributes:$/i) do |table|
    attrs = parse_attrs_table(table)
    variable = "@#{name}"
    eval("#{variable} = build(name, attrs)")
  end
end
