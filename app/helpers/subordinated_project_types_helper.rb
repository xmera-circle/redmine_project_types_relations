# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-21 Liane Hampe <liaham@xmera.de>, xmera.
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

module SubordinatedProjectTypesHelper
  def subordinated_project_types_multiselect(project_type, choices, _options = {})
    return nothing_to_select unless choices.present?

    hidden_field_tag('project[subordinate_ids][]', '').html_safe +
      choices.collect do |choice|
        name, id = (choice.is_a?(Array) ? choice : [choice, choice])
        next if project_type.self?(id) || project_type.superordinate_ids.include?(id)

        content_tag(
          'label',
          check_box_tag(
            'project[subordinate_ids][]',
            id,
            project_type.subordinate_assigned?(id),
            id: nil
          ) + name.to_s,
          class: 'inline' # 'block'
        )
      end.join.html_safe
  end

  private

  def nothing_to_select
    tag.em l(:name_nothing_to_select), class: 'nothing-to-select'
  end

  # def reporting(project_type, subordinate)
  #   out = +''
  #   out << subordinate.name
  #   out << report_number_of_related_projects(project_type, subordinate)
  #   out.html_safe
  # end

  # def report_number_of_related_projects(project_type, subordinate)
  #   tag.em class: 'info' do
  #     count = all_related_projects(project_type, subordinate)
  #     l(:name_number_of_related_projects, count)
  #   end
  # end

  # def all_related_projects(project_type, subordinate)
  #   count = []
  #   assigned_projects(project_type).each do |project|
  #     subordinate.relatives.each do |relative|
  #       count << number_of_relations(project, relative)
  #     end
  #   end
  #   count.sum
  # end

  # def number_of_relations(project, other)
  #   ProjectsRelation.where(guest_id: project.id, host_id: other.id).count
  #   #  .or(ProjectsRelation.where(host_id: project.id, guest_id: other.id)).count
end
