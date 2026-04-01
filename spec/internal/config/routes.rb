# frozen_string_literal: true

Rails.application.routes.draw do
  get "/base", to: "test#base"
  get "/modal", to: "test#modal"
  get "/modal_base", to: "test#modal_base"
  get "/nested_modal", to: "test#nested_modal"
  get "/modal_with_base", to: "test#modal_with_base"
  get "/modal_no_base", to: "test#modal_no_base"
  get "/modal_self_base", to: "test#modal_self_base"

  # Routes for testing implicit rendering on base URL
  get "/implicit_base", to: "implicit#base"
  get "/implicit_modal", to: "implicit#modal"

  # Routes for testing parameter mismatch issue
  get "/projects/:project_id/tasks/:id", to: "projects#show_task"
  get "/areas/:area_id/projects/:id", to: "areas#show_project"
end
