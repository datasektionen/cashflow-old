# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

unless BusinessUnit.any?
  business_unit_attrs = [
    { name: 'D-rektoratet',           short_name: 'drek',
      description: 'Datasektionens styrelse',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Festverksamhet',         short_name: 'dkm',
      description: 'DKMs festverksamhet', email: 'ekom@d.kth.se',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Idrottsverksamhet',      short_name: 'idro',
      description: 'Idrottsverksamhet',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Informationsorganet',    short_name: 'ior',
      description: 'Informationsorganet',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Mottagningen',           short_name: 'mot',
      description: 'Mottagningen', email: 'ekonomeriet@d.kth.se',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Näringslivsgruppen',     short_name: 'ng',
      description: 'Näringslivsgruppen',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Qulturnämnden',          short_name: 'qn',
      description: 'Qulturnämnden',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Sektionen Centralt',     short_name: 'cen',
      description: 'Centralt',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Sektionslokalsgruppen',  short_name: 'slg',
      description: 'Sektionslokalsgruppen',
      mage_number: -1, mage_default_series: 'test'},
    { name: 'Studieresan',            short_name: 'stud',
      description: 'Projektet STUDS',
      mage_number: -1, mage_default_series: 'test'}
  ]
  BusinessUnit.create!(business_unit_attrs)
end

unless ProductType.any?
  product_type_attrs = [
    { name: 'Annonsering', description: 'Annonsering', mage_account_number: 1234 },
    { name: 'Barkitt', description: 'Barkitt', mage_account_number: 1234 },
    { name: 'Cider', description: 'Cider', mage_account_number: 1234 },
    { name: 'Daddetillbehör', description: 'Daddetillbehör', mage_account_number: 1234 },
    { name: 'Dekoration', description: 'Dekoration', mage_account_number: 1234 },
    { name: 'Doqumenteritillbehör', description: 'Doqumenteritillbehör', mage_account_number: 1234 },
    { name: 'Drifvartillbehör', description: 'Drifvartillbehör', mage_account_number: 1234 },
    { name: 'Förbrukningsinventarier', description: 'Förbrukningsinventarier', mage_account_number: 1234 },
    { name: 'Förbrukningsmateriell', description: 'Förbrukningsmateriell', mage_account_number: 1234 },
    { name: 'Hyra inv. & verktyg', description: 'Hyra inventarier och verktyg', mage_account_number: 1234 },
    { name: 'Hyra maskin & andra tekn. anl.', description: 'Hyra maskin och andra tekniska anläggningar', mage_account_number: 1234 },
    { name: 'Hyrbilskostnader', description: 'Hyrbilskostnader', mage_account_number: 1234 },
    { name: 'Inköp kiosk', description: 'Inköp kiosk', mage_account_number: 1234 },
    { name: 'Kontorsmateriell', description: 'Kontorsmateriell', mage_account_number: 1234 },
    { name: 'Läsk', description: 'Läsk', mage_account_number: 1234 },
    { name: 'Lokalhyra', description: 'Lokalhyra', mage_account_number: 1234 },
    { name: 'Mat', description: 'Mat', mage_account_number: 1234 },
    { name: 'Milersättning', description: 'Milersättning', mage_account_number: 1234 },
    { name: 'Mobiltelefoni', description: 'Mobiltelefoni', mage_account_number: 1234 },
    { name: 'Mörkläggningsmaterial', description: 'Mörkläggningsmaterial', mage_account_number: 1234 },
    { name: 'Möten', description: 'Möten', mage_account_number: 1234 },
    { name: 'Personbilar, Parkeringsvagift', description: 'Personbilar, Parkeringsvagift', mage_account_number: 1234 },
    { name: 'Porto', description: 'Porto', mage_account_number: 1234 },
    { name: 'Reklamtrycksaker', description: 'Reklamtrycksaker', mage_account_number: 1234 },
    { name: 'Representation', description: 'Representation', mage_account_number: 1234 },
    { name: 'Sceneri', description: 'Sceneri', mage_account_number: 1234 },
    { name: 'Sprit', description: 'Sprit', mage_account_number: 1234 },
    { name: 'Teknik', description: 'Teknik', mage_account_number: 1234 },
    { name: 'Trängselskatt', description: 'Trängselskatt', mage_account_number: 1234 },
    { name: 'Trycksaker', description: 'Trycksaker', mage_account_number: 1234 },
    { name: 'Verktyg', description: 'Verktyg', mage_account_number: 1234 },
    { name: 'Vin', description: 'Vin', mage_account_number: 1234 },
    { name: 'Öl', description: 'Öl', mage_account_number: 1234 },
    { name: 'Övr. kostn. hyrd lokal', description: 'Övriga kostnader hyrd lokal', mage_account_number: 1234 },
    { name: 'Övr. reklamkostnader', description: 'Övriga reklamkostnader', mage_account_number: 1234 },
    { name: 'Övr. resekostnader', description: 'Övriga resekostnader', mage_account_number: 1234 },
    { name: 'Övrigt', description: 'Övrigt', mage_account_number: 1234 }
  ]
  ProductType.create!(product_type_attrs)
end

unless BudgetPost.any?
  mottagningen = BusinessUnit.find_by_name('Mottagningen')
  budget_post_attrs = [
    { name: 'Överlämning', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Inaug', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'INDA', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'plOsqvik', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'n0lleOsqvik', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Frukost', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Bärbar', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Favvodaddemiddag', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Bilen', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Tjejfika', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'God morgon n0llan', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'DOS', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Sångarafton', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'TTG-föreläsning', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Champangefrukost', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'TTG-lab', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Kultmiddag', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Sektionsgasque', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'n0llebanquette', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Herrpub', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Dammiddag', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Nattorientering', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Kultflimmer', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Laserkrig', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Lunch', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Hurry Scurry', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'LQ-sittning', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'LQ-quarneval', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Mediagasque', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'n0llepubrunda', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'n0llegasque', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'KDE-förkör', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Internfest', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Daddetack', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Tackfest', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Old Boys and Girls', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Efterkör', business_unit: mottagningen, mage_arrangement_number: 0},
    { name: 'Lunchföreläsning', business_unit: mottagningen, mage_arrangement_number: 0}
  ]
  BudgetPost.create!(budget_post_attrs)
end
