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

class RelationIntegrityValidator < ActiveModel::EachValidator
  include Redmine::I18n
  def validate_each(record, attribute, _value)
    return if record.project_type_id_unchanged? || record.project_independent?

    record.errors.add attribute, record.deprecated_hosts_message if record.deprecated_hosts?
    record.errors.add attribute, record.lost_guests_message if record.guests.any?
  end
end
