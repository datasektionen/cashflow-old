# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :my_page, 'Min sida', "#"
    primary.item :purchases, 'Inköp', purchases_path, :highlights_on => /\/purchases/ do |sub|
      sub.item :all_purchases, "Alla inköp", purchases_path
      sub.item :new_purchase, "Lägg till inköp", new_purchase_path
    end
    primary.item :people, "Användare", people_path, :highlights_on => /\/people/
    primary.item :business_units, "Affärsenheter", business_units_path, :highlights_on => /\/business_units/ do |sub|
      sub.item :all_business_units, "Alla affärsenheter", business_units_path
      sub.item :new_business_unit, "Ny affärsenhet", new_business_unit_path
    end
    primary.item :product_types, "Produkttyper", product_types_path, :highlights_on => /\/product_types/ do |sub|
      sub.item :all_product_types, "Alla produkttyper", product_types_path
      sub.item :new_product_type, "Ny produkttyp", new_product_type_path
    end
  end
end