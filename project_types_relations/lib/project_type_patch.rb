require_dependency 'project_type'

module ProjectTypePatch
  
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      # Validations
      validates :related_to, :uniqueness => true, :allow_blank => true, :allow_nil => true
      validate :validate_relation, :on => :update
      validate :validate_is_project_type
          
    end
   end
  
  module ClassMethods
    
  end
  
  module InstanceMethods

  def validate_relation
    if id == related_to
      errors.add(:related_to, l(:error_validate_relation))
    end
  end
  
  def validate_is_project_type
    unless related_to.nil? || related_to.blank?
      unless ProjectType.find_by(id: related_to).is_a?(ProjectType)
        errors.add(:related_to, l(:error_validate_is_project_type))
      end
    end
  end
  
  end # module InstanceMethods
  
end # module ProjectTypePatch

ProjectType.send(:include, ProjectTypePatch)