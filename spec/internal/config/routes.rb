# frozen_string_literal: true

Rails.application.routes.draw do
  get "/base", to: "test#base"
  get "/modal", to: "test#modal"
end
