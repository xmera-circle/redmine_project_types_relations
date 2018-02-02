require_dependency 'project'


module ProjectsRelationsProjectPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
      
    base.send(:include, InstanceMethods)
      
    base.class_eval do
      unloadable

      # Associations
      has_many :projects_relations, foreign_key: :project_id, dependent: :destroy
      
    end
  end

  module ClassMethods
    
  end # module ClassMethods
  
  module InstanceMethods
    
  end # module InstanceMethods
 

end # module ProjectsRelationsProjectPatch

Project.send(:include, ProjectsRelationsProjectPatch)