class ProjectRelationsHookListener < Redmine::Hook::ViewListener
  render_on :view_projects_show_right, :partial => "projects_relations/project_overview" 
end