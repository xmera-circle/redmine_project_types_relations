# frozen_string_literal: true

# Redmine plugin for xmera called Project Types Relations Plugin.
#
# Copyright (C) 2017-2023 Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
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

# rubocop:disable Rails/OutputSafety
module SubordinatedProjectTypesHelper
  def subordinated_project_types_multiselect(project_type, choices, _options = {})
    return no_data if choices.blank?

    hidden_field_tag('project[subordinate_ids][]', '').html_safe +
      choices.collect do |choice|
        name, id = (choice.is_a?(Array) ? choice : [choice.name, choice.id])
        next if project_type.self?(id) || project_type.superordinate_ids.include?(id)

        render_subordinated_check_box(id, name, project_type)
      end.join.html_safe
  end

  private

  def render_subordinated_check_box(id, name, project_type)
    content_tag('label',
                check_box_tag(
                  'project[subordinate_ids][]',
                  id,
                  project_type.subordinate_assigned?(id),
                  id: nil
                ) + name.to_s,
                class: 'floating') # 'block'
  end

  def no_data
    tag.div l(:label_no_data), class: 'nodata half-width'
  end
end
# rubocop:enable Rails/OutputSafety
