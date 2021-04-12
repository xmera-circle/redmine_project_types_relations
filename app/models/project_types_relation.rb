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

class ProjectTypesRelation < ActiveRecord::Base
  belongs_to :superordinate, class_name: 'ProjectType'
  belongs_to :subordinate, class_name: 'ProjectType'

  validate :subordinate_relations

  scope :superordinates, ->(id) { where(subordinate_id: id).map(&:superordinate).compact }

  private

  def subordinate_relations
    return unless changed?

    check_self_relation
    check_circular_reference
  end

  def check_self_relation
    return true unless self_relation?

    errors.add subordinate.name, l(:error_validate_circular_reference)
  end

  def check_circular_reference
    return true unless circular_reference?

    errors.add subordinate.name, l(:error_validate_circular_reference)
  end

  def circular_reference?
    return false unless subordinate.present?

    filter_for_superordinate_ids.include? subordinate.id
  end

  def filter_for_superordinate_ids
    self.class.where(subordinate_id: superordinate.id).pluck(:superordinate_id)
  end

  def relations_to_be_deleted?
    new_values.all?(&:zero?)
  end

  def self_relation?
    new_values.first == new_values.last
  end

  def new_values
    changes.values.map(&:second)
  end
end
