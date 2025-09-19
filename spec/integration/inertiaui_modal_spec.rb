# frozen_string_literal: true

require "spec_helper"

RSpec.describe "InertiaUI Modal Integration", type: :request do
  describe "GET /modal" do
    let(:expected_modal) do
      {
        component: "modal",
        props: {hello: "modal"},
        url: "/modal",
        version: "1",
        encryptHistory: false,
        clearHistory: false,
        baseUrl: "/base",
        meta: {
          deferredProps: {
            default: ["deferred_param"],
            custom: ["merge_param"]
          },
          mergeProps: ["merge_param"]
        }
      }
    end

    let(:expected_page) do
      {
        component: "base",
        props: {
          base: "prop",
          _inertiaui_modal: expected_modal
        },
        url: "/modal",
        version: "1",
        encryptHistory: false,
        clearHistory: false
      }
    end

    let(:expected_defer_modal) do
      {
        component: "modal",
        props: {deferred_param: "deferred"},
        url: "/modal",
        version: "1",
        encryptHistory: false,
        clearHistory: false
      }
    end

    it "returns page data with base & modal merged together" do
      get "/modal"

      expect(response.status).to eq(200)
      expect(page_data).to eq(expected_page.as_json)
    end

    it "returns base & modal merged together when requested with X-Inertia: true header" do
      get "/modal", headers: {
        "X-Inertia" => "true",
        "X-Inertia-Version" => "1"
      }

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(expected_page.as_json)
    end

    it "returns modal ID prop when provided" do
      get "/modal", headers: {
        "X-Inertia" => "true",
        "X-Inertia-Version" => "1",
        "X-InertiaUI-Modal" => "inertiaui_modal_198a8978-df9e-41c5-97ea-cd100651e80e"
      }

      expected_modal[:id] = "inertiaui_modal_198a8978-df9e-41c5-97ea-cd100651e80e"
      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(expected_page.as_json)
    end

    it "returns only deferred props when requested" do
      get "/modal", headers: {
        "X-Inertia" => "true",
        "X-Inertia-Version" => "1",
        "X-InertiaUI-Modal-Use-Router" => "0",
        "X-Inertia-Partial-Component" => "modal",
        "X-Inertia-Partial-Data" => "deferred_param"
      }

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(expected_defer_modal.as_json)
    end

    def page_data
      doc = Nokogiri::HTML(response.body)
      data_page = doc.at_css("#app")&.[]("data-page")
      return nil unless data_page

      JSON.parse(CGI.unescapeHTML(data_page))
    end
  end

  describe "when base URL uses other param names" do
    it "receives correct parameters from base URL" do
      get "/projects/789/tasks/456"

      expect(response.status).to eq(200)
    end
  end
end
