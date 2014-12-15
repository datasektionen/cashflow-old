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
    { name: 'D-rektoratet', short_name: 'drek', description: 'Datasektionens styrelse' },
    { name: 'Festverksamhet', short_name: 'dkm', description: 'DKMs festverksamhet', email: 'ekom@d.kth.se' },
    { name: 'Idrottsverksamhet', short_name: 'idro', description: 'Idrottsverksamhet' },
    { name: 'Informationsorganet', short_name: 'ior', description: 'Informationsorganet' },
    { name: 'Mottagningen', short_name: 'mot', description: 'Mottagningen', email: 'ekonomeriet@d.kth.se' },
    { name: 'Näringslivsgruppen', short_name: 'ng', description: 'Näringslivsgruppen' },
    { name: 'Qulturnämnden', short_name: 'qn', description: 'Qulturnämnden' },
    { name: 'Sektionen Centralt', short_name: 'cen', description: 'Centralt' },
    { name: 'Sektionslokalsgruppen', short_name: 'slg', description: 'Sektionslokalsgruppen' },
    { name: 'Studieresan', short_name: 'stud', description: 'Projektet STUDS' }
  ]
  BusinessUnit.create!(business_unit_attrs)
end

unless ProductType.any?
  product_type_attrs = [
    { name: 'Annonsering', description: 'Annonsering' },
    { name: 'Barkitt', description: 'Barkitt' },
    { name: 'Cider', description: 'Cider' },
    { name: 'Daddetillbehör', description: 'Daddetillbehör' },
    { name: 'Dekoration', description: 'Dekoration' },
    { name: 'Doqumenteritillbehör', description: 'Doqumenteritillbehör' },
    { name: 'Drifvartillbehör', description: 'Drifvartillbehör' },
    { name: 'Förbrukningsinventarier', description: 'Förbrukningsinventarier' },
    { name: 'Förbrukningsmateriell', description: 'Förbrukningsmateriell' },
    { name: 'Hyra inv. & verktyg', description: 'Hyra inventarier och verktyg' },
    { name: 'Hyra maskin & andra tekn. anl.', description: 'Hyra maskin och andra tekniska anläggningar' },
    { name: 'Hyrbilskostnader', description: 'Hyrbilskostnader' },
    { name: 'Inköp kiosk', description: 'Inköp kiosk' },
    { name: 'Kontorsmateriell', description: 'Kontorsmateriell' },
    { name: 'Läsk', description: 'Läsk' },
    { name: 'Lokalhyra', description: 'Lokalhyra' },
    { name: 'Mat', description: 'Mat' },
    { name: 'Milersättning', description: 'Milersättning' },
    { name: 'Mobiltelefoni', description: 'Mobiltelefoni' },
    { name: 'Mörkläggningsmaterial', description: 'Mörkläggningsmaterial' },
    { name: 'Möten', description: 'Möten' },
    { name: 'Personbilar, Parkeringsvagift', description: 'Personbilar, Parkeringsvagift' },
    { name: 'Porto', description: 'Porto' },
    { name: 'Reklamtrycksaker', description: 'Reklamtrycksaker' },
    { name: 'Representation', description: 'Representation' },
    { name: 'Sceneri', description: 'Sceneri' },
    { name: 'Sprit', description: 'Sprit' },
    { name: 'Teknik', description: 'Teknik' },
    { name: 'Trängselskatt', description: 'Trängselskatt' },
    { name: 'Trycksaker', description: 'Trycksaker' },
    { name: 'Verktyg', description: 'Verktyg' },
    { name: 'Vin', description: 'Vin' },
    { name: 'Öl', description: 'Öl' },
    { name: 'Övr. kostn. hyrd lokal', description: 'Övriga kostnader hyrd lokal' },
    { name: 'Övr. reklamkostnader', description: 'Övriga reklamkostnader' },
    { name: 'Övr. resekostnader', description: 'Övriga resekostnader' },
    { name: 'Övrigt', description: 'Övrigt' }
  ]
  ProductType.create!(product_type_attrs)
end

unless BudgetPost.any?
  mottagningen = BusinessUnit.find_by_name('Mottagningen')
  budget_post_attrs = [
    { name: 'Överlämning', business_unit: mottagningen },
    { name: 'Inaug', business_unit: mottagningen },
    { name: 'INDA', business_unit: mottagningen },
    { name: 'plOsqvik', business_unit: mottagningen },
    { name: 'n0lleOsqvik', business_unit: mottagningen },
    { name: 'Frukost', business_unit: mottagningen },
    { name: 'Bärbar', business_unit: mottagningen },
    { name: 'Favvodaddemiddag', business_unit: mottagningen },
    { name: 'Bilen', business_unit: mottagningen },
    { name: 'Tjejfika', business_unit: mottagningen },
    { name: 'God morgon n0llan', business_unit: mottagningen },
    { name: 'DOS', business_unit: mottagningen },
    { name: 'Sångarafton', business_unit: mottagningen },
    { name: 'TTG-föreläsning', business_unit: mottagningen },
    { name: 'Champangefrukost', business_unit: mottagningen },
    { name: 'TTG-lab', business_unit: mottagningen },
    { name: 'Kultmiddag', business_unit: mottagningen },
    { name: 'Sektionsgasque', business_unit: mottagningen },
    { name: 'n0llebanquette', business_unit: mottagningen },
    { name: 'Herrpub', business_unit: mottagningen },
    { name: 'Dammiddag', business_unit: mottagningen },
    { name: 'Nattorientering', business_unit: mottagningen },
    { name: 'Kultflimmer', business_unit: mottagningen },
    { name: 'Laserkrig', business_unit: mottagningen },
    { name: 'Lunch', business_unit: mottagningen },
    { name: 'Hurry Scurry', business_unit: mottagningen },
    { name: 'LQ-sittning', business_unit: mottagningen },
    { name: 'LQ-quarneval', business_unit: mottagningen },
    { name: 'Mediagasque', business_unit: mottagningen },
    { name: 'n0llepubrunda', business_unit: mottagningen },
    { name: 'n0llegasque', business_unit: mottagningen },
    { name: 'KDE-förkör', business_unit: mottagningen },
    { name: 'Internfest', business_unit: mottagningen },
    { name: 'Daddetack', business_unit: mottagningen },
    { name: 'Tackfest', business_unit: mottagningen },
    { name: 'Old Boys and Girls', business_unit: mottagningen },
    { name: 'Efterkör', business_unit: mottagningen },
    { name: 'Lunchföreläsning', business_unit: mottagningen }
  ]
  BudgetPost.create!(budget_post_attrs)
end
