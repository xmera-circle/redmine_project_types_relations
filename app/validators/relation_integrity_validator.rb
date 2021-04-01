class RelationIntegrityValidator  < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if false
      record.errors.add attribute, :invalid
    end
  end
end