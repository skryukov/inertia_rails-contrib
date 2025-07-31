# frozen_string_literal: true

class ProjectsController < ActionController::Base
  layout "application"

  def show_task
    # This action expects :project_id and :id parameters
    project_id = params[:project_id]
    task_id = params[:id]

    # Simulate looking up records with expected parameters
    raise "Missing project_id parameter" if project_id.blank?
    raise "Missing task id parameter" if task_id.blank?

    render inertia_modal: "TaskModal", props: {
      project_id: project_id,
      task_id: task_id,
      message: "Task #{task_id} in project #{project_id}"
    }, base_url: "/areas/123/projects/#{task_id}"
  end
end
