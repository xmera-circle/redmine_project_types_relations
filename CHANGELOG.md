# Changelog for Project Types Relations

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.5 - 2022-05-18

### Changed

* copyright year
* README to the latest template

## 2.0.4 - 2021-05-29

### Changed

* structure in lib dir
* styling of no data user notice

## 2.0.3 - 2021-04-22

### Changed

* ProjectsControllerPatchTest to support Redmine 4.2

### Added

* NullProjectType patch and test
* ProjectType patch

## 2.0.2 - 2021-04-19

### Removed

* after_initialize callback in Project patch which was the reason for a memory leak

### Added

* instance variables in ProjectsController#settings in order to improve performance

### Changed

* some further methods to improve performance

## 2.0.1 - 2021-04-14

### Changed

* some methods to improve performance w.r.t. subordinated project types

## 2.0.0 - 2021-04-08

### Changed

* the codebase to be compatible with redmine_project_types 4.0.0
* some methods to improve performance

### Added

* rubcop configuration file

## 1.0.1 - 2021-02-28

### Changed

* ViewProjectsShowRightHookListener class to allow inheritation by other
  plugins

* some label

## 1.0.0 - 2021-02-19

### Added

* Redmine 4.1.1 support

### Changed

* association tables
* Redmine core patches

## 0.2.3 - 2019-04-26

### Added

* Redmine 3.4.10 Support

## 0.2.2 - 2019-01-15

### Added

* some documentation in init.rb and test files

### Changed

* fixture path in fixture_handling.rb
* migration files to avoid errors of mysql2 when running migration more than once

## 0.2.1 - 2018-19-27

### Added

* Redmine 3.4.6 Support

## 0.2.0 - 2018-01-30

### Added

* licence text to all relevant files
* call hook for project view

### Changed

* folders and files to meet a better structure for patching redmine core
* CHANGELOG and README to *.md files

## 0.1.3 - 2017-12-03

### Changed

* some :de label values

## 0.1.2 - 2017-11-26

### Changed

* requirement for redmine to 3.3.2 or higher

## 0.1.1 - 2017-05-03

### Added

* assigned resource box to projects overview

### Changed

* all project related labels to 'object'

## 0.1.0 - 2017-04-28

### Added

* initial alpha version
