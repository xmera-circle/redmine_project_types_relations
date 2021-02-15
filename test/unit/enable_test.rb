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

require File.expand_path('../../test_helper', __FILE__)

class EnableTest < ActiveSupport::TestCase
 
  def test_klass_should_respond_to_enable
    assert klass.new.respond_to? :enable
  end

  def test_klass_should_enable_test_method
    assert_equal klass.test_method, klass.new.enable(:test_method)
  end

  private

  def klass
    Class.new do
      include ProjectTypesRelations::Relations::Enable

      def self.test_method
        'success'
      end
    end
  end
  
end
