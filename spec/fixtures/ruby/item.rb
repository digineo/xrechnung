load("spec/fixtures/ruby/tax_category.rb")

def build_item
  Xrechnung::Item.new(
    description:                     "Leimbinder 2x18m; Birke",
    name:                            "Leimbinder",
    standard_item_identification_id: Xrechnung::Id.new("L218", "0160"),
    commodity_classification:        nil,
    classified_tax_category:         build_tax_category,
  )
end
