# frozen_string_literal: true

Rails.application.routes.draw do
  get "/base", to: "test#base"
  get "/modal", to: "test#modal"

  # Routes for testing parameter mismatch issue
  get "/projects/:project_id/tasks/:id", to: "projects#show_task"
  get "/areas/:area_id/projects/:id", to: "areas#show_project"
end
