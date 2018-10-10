# Redmine plugin for xmera:isms called Project Types Relations Plugin
#
# Copyright (C) 2017-18 Liane Hampe <liane.hampe@xmera.de>
#
# The code below is taken from:
#
# Copyright © 2011    Vít Jonáš <vit.jonas@gmail.com>
# Copyright © 2012    Daniel Munn <dan.munn@munnster.co.uk>
# Copyright © 2011-15 Karel Pičman <karel.picman@kontron.com>
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module ProjectTypesRelations
  module Test
    class TestCase < Redmine::ControllerTest#ActionController::TestCase
      extend ProjectTypesRelations::Test::FixturesHandling     
      def setup
        @request = ActionController::TestRequest.new
        @response = ActionController::TestResponse.new
        @request.session[:user_id] = nil
        Setting.default_language = 'en'
      end 
    end
  end
end