require_dependency 'projects_controller'


module ProjectsRelationsProjectsControllerPatch
unloadable

include ProjectsRelationsHelper

def update
    if @project.update(project_params)
      unless params[:projects_relation].nil? || @project.projects_project_type.previous_changes.present?
       @projects_relations = ProjectsRelation.where(project_id: @project.id)
       create_multi_related_projects(@projects_relations, projects_relation_params)
      end
       respond_to do |format|
       format.html {
        flash[:notice] = l(:notice_successful_update)
        redirect_to settings_project_path(@project)
       }
       format.api  { render_api_ok }
    end
  else
    respond_to do |format|
       format.html {
        settings
        render :action => 'settings'
       }
       format.api  { render_validation_errors(@project) }
    end
  end
end
    
private
    
 def projects_relation_params
   params.require(:projects_relation).permit(:project_id, :related_project => [])
 end
  
end # module ProjectsRelationsProjectsControllerPatch

ProjectsController.send(:prepend, ProjectsRelationsProjectsControllerPatch)
