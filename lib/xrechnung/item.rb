module Xrechnung
  Item = Struct.new(:description, :name, :standard_item_identification_id,
    :commodity_classification, :classified_tax_category, keyword_init: true) do
    # noinspection RubyResolve
    def to_xml(xml)
      xml.cac :Item do
        xml.cbc :Description, description
        xml.cbc :Name, name
        xml.cac :StandardItemIdentification do
          xml.cbc :ID, standard_item_identification_id.id, schemeID: standard_item_identification_id.scheme_id
        end
        xml.cac :CommodityClassification, commodity_classification
        classified_tax_category&.to_xml(xml, root_tag_name: :ClassifiedTaxCategory)
      end
    end
  end
end
