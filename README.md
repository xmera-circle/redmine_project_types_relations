Project Types Relations Plugin
==============================

The current version of Project Types Relations Plugin is **1.0.0**.

Project Types Relations is a plugin for xmera:isms based on Redmine.
It allows to define individual relations between project types.

Initial development was for xmera e.K. and it is released as open source.
Project home: <http://#>

Project Types Relations Plugin is distributed under GNU General Public License v2 (GPL).  
Redmine is a flexible project management web application, released under the terms of the GNU General Public License v2 (GPL) at <http://www.redmine.org/>

Further information about the GPL license can be found at
<http://www.gnu.org/licenses/old-licenses/gpl-2.0.html#SEC1>

Features
--------

* Define individual relations between project types


Dependencies
------------
  
  * Redmine 3.3.2 or higher

Usage
-----

1. Go to admin menu -> object types -> edit object type
1. Define the object type relation by choosing the subordinated object type



Setup / Upgrade
---------------

Before installing ensure that the Redmine instance is stopped.

1. Put project_types plugin directory into plugins.
1. Run a migration with: `RAILS_ENV=production rake redmine:plugins:migrate NAME=project_types`
1. Restart the web server.

Uninstalling
------------

Before uninstalling the Project Types Plugin, please ensure that the Redmine instance is stopped.

1. `cd [redmine-install-dir]`
1. ``RAILS_ENV=production rake redmine:plugins:migrate VERSION= 0 NAME=project_types`
1. `rm plugins/project_types -Rf`

After these steps restart your instance of Redmine.

Contributing
------------

If you've added something, why not share it. Fork the repository (github.com/#), 
make the changes and send a pull request to the maintainers.

Changes with tests, and full documentation are preferred.

Additional Documentation
------------------------

[CHANGELOG.md](CHANGELOG.md) - Project changelog
