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
  def subordinated_project_types_multiselect(_project_type_id, choices, _options = {})
    return nothing_to_select unless available_subordinates?

    hidden_field_tag('project_type[subordinate_ids][]', '').html_safe +
      choices.collect do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag(
          'label',
          check_box_tag(
            'project_type[subordinate_ids][]',
            value,
            @project_type.subordinate_assigned?(value),
            id: nil
          ) + text.to_s,
          class: 'inline' # 'block'
        )
      end.join.html_safe
  end

  def available_subordinates?
    available_subordinates.present?
  end

  def available_subordinates
    superordinates = superordinates_of(@project_type)
    subordinates = subordinates_of(@project_type, superordinates)
    subordinates.collect { |t| [t.name, t.id.to_s] }
  end

  def nothing_to_select
    tag.em l(:message_nothing_to_select), class: 'nothing-to-select'
  end

  def subordinates_of(project_type, superordinates)
    project_type.new_record? ? superordinates.sorted : superordinates.where.not(id: project_type.id).sorted
  end

  ##
  # Avoid circular dependencies: a superordinate of a project_type cannot be a
  # subordinate at the same time.
  #
  def superordinates_of(project_type)
    superordinates = ProjectType.where.not(id: project_type.superordinate_ids)
    project_type.new_record? || superordinates.empty? ? ProjectType : superordinates
  end
end
