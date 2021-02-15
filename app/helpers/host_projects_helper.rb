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

module HostProjectsHelper
  def host_projects_multiselect(project_id, choices, _options={})
    return nothing_to_select unless available_hosts?

      hidden_field_tag("project[host_ids][]", '').html_safe +
      choices.collect do |choice|
        text, value = (choice.is_a?(Array) ? choice : [choice, choice])
        content_tag(
          'label',
          check_box_tag(
             "project[host_ids][]",
             value,
             @project.host_assigned?(value),
             :id => nil
           ) + text.to_s,
          :class => 'inline' #'block'
         )
      end.join.html_safe
  end

  def render_associated_projects(project:, category:, label_left:, label_right:)
    columns = %I[#{label_left} #{label_right} ]
    create_table(project, category, columns)
  end

  private

  def available_hosts?
    available_hosts.present?
  end

  def available_hosts
    guests = guests_of(@project)
    hosts = hosts_of(@project, guests)
    hosts.collect { |t| [t.name, t.id.to_s] }
  end

  def nothing_to_select
    tag.em l(:message_nothing_to_select), class: 'nothing-to-select'
  end

  def hosts_of(project, guests)
    project.new_record? ? guests.sorted : guests.where.not(id: project.id).sorted
  end

  ##
  # Avoid circular dependencies: a guest of a project cannot be a
  # host at the same time.
  #
  # Additionally, only projects with a subordinated project type are considered.
  #
  def guests_of(project)
    guests = scoped_by_project_type(project).where.not(id: project.guest_ids)
    project.new_record? || guests.empty? ? scoped_by_project_type(project) : guests
  end

  def scoped_by_project_type(project)
    project.project_type ? Project.where(project_type_id: project.project_type.subordinate_ids) : Project
  end

  def create_table(project, category, columns)
    return '' unless associates?(project, category)

    content_tag :table, create_thead(columns).concat(create_tbody(project, category)), class: 'list'
  end

  def associates?(project, category)
    project.send(category).present?
  end

  def create_thead(columns)
    thead = content_tag :thead do
      content_tag :tr do
        columns.collect { |column| concat content_tag(:th, l(column), class: 'name') }.join().html_safe
      end
    end
  end

  def create_tbody(project, category)
    content_tag :tbody do
      associate_grouped_by_project_type(project, category).collect { |project_type, associate|
        content_tag :tr do
          concat content_tag(:td, project_type, class: 'name').to_s.html_safe
          concat content_tag(:td, list_of_associate_links(associate), class: 'name').to_s.html_safe
        end
      }.join().html_safe
    end
  end

  def associate_grouped_by_project_type(project, category)
    project.send(category).group_by { |associate| associate.project_type.name }
  end

  def list_of_associate_links(associates)
    list = []
    associates.each { |associate| list << link_to_associate(associate) }
    list.join(', ').html_safe
  end

  def link_to_associate(associate)
    link_to(associate.name, project_path(associate))
  end
end
