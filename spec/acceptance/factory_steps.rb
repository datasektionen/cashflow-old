steps_for :factory do
  def parse_attrs_table(table)
    attrs = {}
    table.raw.each do |(attr, value)|
      sanitized_attr = attr.gsub(/\s+/,"-").underscore
      attrs[sanitized_attr.to_sym] = value
    end
    attrs
  end

  step "a :model with the following attributes:" do |model, attrs_table|
    attrs = parse_attrs_table(attrs_table)
    variable = "@#{model}"
    eval("#{variable} = Factory(model, attrs)")
  end
  step "a new :model with the following attributes:" do |model, attrs_table|
    attrs = parse_attrs_table(attrs_table)
    variable = "@#{model}"
    eval("#{variable} = Factory.build(model, attrs)")
  end
end

