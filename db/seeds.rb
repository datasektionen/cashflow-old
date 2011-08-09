# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

BudgetPost.create!({:name => "Överlämning"})
BudgetPost.create!({:name => "Inaug"})
BudgetPost.create!({:name => "INDA"})
BudgetPost.create!({:name => "plOsqvik"})
BudgetPost.create!({:name => "n0lleOsqvik"})
BudgetPost.create!({:name => "Frukost"})
BudgetPost.create!({:name => "Bärbar"})
BudgetPost.create!({:name => "Favvodaddemiddag"})
BudgetPost.create!({:name => "Bilen"})
BudgetPost.create!({:name => "Tjejfika"})
BudgetPost.create!({:name => "God morgon n0llan"})
BudgetPost.create!({:name => "DOS"})
BudgetPost.create!({:name => "Sångarafton"})
BudgetPost.create!({:name => "TTG-föreläsning"})
BudgetPost.create!({:name => "Champangefrukost"})
BudgetPost.create!({:name => "TTG-lab"})
BudgetPost.create!({:name => "Kultmiddag"})
BudgetPost.create!({:name => "Sektionsgasque"})
BudgetPost.create!({:name => "n0llebanquette"})
BudgetPost.create!({:name => "Herrpub"})
BudgetPost.create!({:name => "Dammiddag"})
BudgetPost.create!({:name => "Nattorientering"})
BudgetPost.create!({:name => "Kultflimmer"})
BudgetPost.create!({:name => "Laserkrig"})
BudgetPost.create!({:name => "Lunch"})
BudgetPost.create!({:name => "Hurry Scurry"})
BudgetPost.create!({:name => "LQ-sittning"})
BudgetPost.create!({:name => "LQ-quarneval"})
BudgetPost.create!({:name => "Mediagasque"})
BudgetPost.create!({:name => "n0llepubrunda"})
BudgetPost.create!({:name => "n0llegasque"})
BudgetPost.create!({:name => "KDE-förkör"})
BudgetPost.create!({:name => "Internfest"})
BudgetPost.create!({:name => "Daddetack"})
BudgetPost.create!({:name => "Tackfest"})
BudgetPost.create!({:name => "Old Boys and Girls"})
BudgetPost.create!({:name => "Efterkör"})
BudgetPost.create!({:name => "Lunchföreläsning"})

BusinessUnit.create!({:name => "D-rektoratet", :short_name => "drek", :description => "Datasektionens styrelse"})
BusinessUnit.create!({:name => "Festverksamhet", :short_name => "dkm", :description => "DKMs festverksamhet", :email => "ekom@d.kth.se"})
BusinessUnit.create!({:name => "Idrottsverksamhet", :short_name => "idro", :description => "Idrottsverksamhet"})
BusinessUnit.create!({:name => "Informationsorganet", :short_name => "ior", :description => "Informationsorganet"})
BusinessUnit.create!({:name => "Mottagningen", :short_name => "mot", :description => "Mottagningen", :email => "ekonomeriet@d.kth.se"})
BusinessUnit.create!({:name => "Näringslivsgruppen", :short_name => "ng", :description => "Näringslivsgruppen"})
BusinessUnit.create!({:name => "Qulturnämnden", :short_name => "qn", :description => "Qulturnämnden"})
BusinessUnit.create!({:name => "Sektionen Centralt", :short_name => "cen", :description => "Centralt"})
BusinessUnit.create!({:name => "Sektionslokalsgruppen", :short_name => "slg", :description => "Sektionslokalsgruppen"})
BusinessUnit.create!({:name => "Studieresan", :short_name => "stud", :description => "Projektet STUDS"})

ProductType.create!({:name => "Annonsering", :description => "Annonsering"})
ProductType.create!({:name => "Barkitt", :description => "Barkitt"})
ProductType.create!({:name => "Cider", :description => "Cider"})
ProductType.create!({:name => "Daddetillbehör", :description => "Daddetillbehör"})
ProductType.create!({:name => "Dekoration", :description => "Dekoration"})
ProductType.create!({:name => "Doqumenteritillbehör", :description => "Doqumenteritillbehör"})
ProductType.create!({:name => "Drifvartillbehör", :description => "Drifvartillbehör"})
ProductType.create!({:name => "Förbrukningsinventarier", :description => "Förbrukningsinventarier"})
ProductType.create!({:name => "Förbrukningsmateriell", :description => "Förbrukningsmateriell"})
ProductType.create!({:name => "Hyra inv. & verktyg", :description => "Hyra inventarier och verktyg"})
ProductType.create!({:name => "Hyra maskin & andra tekn. anl.", :description => "Hyra maskin och andra tekniska anläggningar"})
ProductType.create!({:name => "Hyrbilskostnader", :description => "Hyrbilskostnader"})
ProductType.create!({:name => "Inköp kiosk", :description => "Inköp kiosk"})
ProductType.create!({:name => "Kontorsmateriell", :description => "Kontorsmateriell"})
ProductType.create!({:name => "Läsk", :description => "Läsk"})
ProductType.create!({:name => "Lokalhyra", :description => "Lokalhyra"})
ProductType.create!({:name => "Mat", :description => "Mat"})
ProductType.create!({:name => "Milersättning", :description => "Milersättning"})
ProductType.create!({:name => "Mobiltelefoni", :description => "Mobiltelefoni"})
ProductType.create!({:name => "Mörkläggningsmaterial", :description => "Mörkläggningsmaterial"})
ProductType.create!({:name => "Möten", :description => "Möten"})
ProductType.create!({:name => "Personbilar, Parkeringsvagift", :description => "Personbilar, Parkeringsvagift"})
ProductType.create!({:name => "Porto", :description => "Porto"})
ProductType.create!({:name => "Reklamtrycksaker", :description => "Reklamtrycksaker"})
ProductType.create!({:name => "Representation", :description => "Representation"})
ProductType.create!({:name => "Sceneri", :description => "Sceneri"})
ProductType.create!({:name => "Sprit", :description => "Sprit"})
ProductType.create!({:name => "Teknik", :description => "Teknik"})
ProductType.create!({:name => "Trängselskatt", :description => "Trängselskatt"})
ProductType.create!({:name => "Trycksaker", :description => "Trycksaker"})
ProductType.create!({:name => "Verktyg", :description => "Verktyg"})
ProductType.create!({:name => "Vin", :description => "Vin"})
ProductType.create!({:name => "Öl", :description => "Öl"})
ProductType.create!({:name => "Övr. kostn. hyrd lokal", :description => "Övriga kostnader hyrd lokal"})
ProductType.create!({:name => "Övr. reklamkostnader", :description => "Övriga reklamkostnader"})
ProductType.create!({:name => "Övr. resekostnader", :description => "Övriga resekostnader"})
ProductType.create!({:name => "Övrigt", :description => "Övrigt"})
