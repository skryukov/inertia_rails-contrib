# frozen_string_literal: true

class AreasController < ActionController::Base
  layout "application"

  def show_project
    # This action expects :area_id and :id parameters
    area_id = params[:area_id]
    project_id = params[:id]

    # Simulate looking up records with expected parameters
    raise "Missing area_id parameter" if area_id.blank?
    raise "Missing project id parameter" if project_id.blank?

    # This will fail if we receive :project_id instead of :area_id
    if params[:project_id].present? && area_id.blank?
      raise "Received project_id parameter but expected area_id parameter - this demonstrates the parameter mismatch issue"
    end

    render inertia: "ProjectPage", props: {
      area_id: area_id,
      project_id: project_id,
      message: "Project #{project_id} in area #{area_id}"
    }
  end
end
