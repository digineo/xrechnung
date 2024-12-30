def build_additional_document_reference
  Xrechnung::AdditionalDocumentReference.new(
    id:                   "CR44123",
    document_type:        "Consumption report",
    document_description: "Lorem Ipsum",
    attachment:           Xrechnung::Attachment.new(
      payload:   "Hello World",
      mime_code: "text/plain",
      filename:  "attachment.txt",
    ),
  )
end
