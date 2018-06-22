# Redmine plugin for xmera:isms called Project Types Relations Plugin
#
# Copyright (C) 2017-18 Liane Hampe <liane.hampe@xmera.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

class ProjectsRelation < ActiveRecord::Base
  unloadable
  
  # Associations
  belongs_to :project

  # Validations
  validate :validate_related_project
  
  def self.relations(project)
    if relations_down?(project) && relations_up?(project)
      self.where('project_id=? OR related_project=?', project.id, project.id)
    else
      ( relations_down?(project) ? relations_down(project) : relations_up(project) ) if relations?(project)
    end
  end
  
  def self.relations?(project)
    relations_down?(project) || relations_up?(project)
  end
  
  def self.relations_down(project)
    ProjectsRelation.where(project_id: project.id) if relations_down?(project)
  end
  
  def self.relations_down?(project)
    ProjectsRelation.where(project_id: project.id).present?
  end
  
  def self.relations_up(project)
    ProjectsRelation.where(related_project: project.id) if relations_up?(project)
  end
  
  def self.relations_up?(project)
    ProjectsRelation.where(related_project: project.id).present?
  end
  
  def self.has?(other_project)
    # Find out from where the method call came 
    caller_methods = caller_locations.map(&:label).uniq
    if caller_methods.include?('down_assigned_projects')
      return self.pluck(:related_project).include?(other_project.id)
    end
    if caller_methods.include?('up_assigned_projects')
      return self.pluck(:project_id).include?(other_project.id)
    end
  end
  
  private
  
  def validate_related_project
    if ProjectsProjectType.find_by(project_id: project_id).nil?
      projects_project_type_id = nil
    else
      projects_project_type_id = ProjectsProjectType.find_by(project_id: project_id).project_type_id
    end
        
    if ProjectsProjectType.find_by(project_id: related_project).nil?
      given_related_projects_project_type_id = nil
    else
      given_related_projects_project_type_id = ProjectsProjectType.find_by(project_id: related_project).project_type_id
    end
     
    if projects_project_type_id == 0 || projects_project_type_id.nil?
      expected_related_projects_project_type_id = nil
    else
      expected_related_projects_project_type_id = ProjectType.find(projects_project_type_id).related_to
    end
    
    if (expected_related_projects_project_type_id.nil? && given_related_projects_project_type_id.nil?) || expected_related_projects_project_type_id != given_related_projects_project_type_id
      errors.add(:related_project, l(:error_validate_related_project))
    end
  end
end
