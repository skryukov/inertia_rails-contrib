# frozen_string_literal: true

require "spec_helper"

RSpec.describe "InertiaUI Modal Integration", type: :request do
  def page_data
    doc = Nokogiri::HTML(response.body)
    data_page = doc.at_css("#app")&.[]("data-page")
    return nil unless data_page

    JSON.parse(CGI.unescapeHTML(data_page))
  end

  describe "GET /modal" do
    let(:expected_modal) do
      {
        component: "modal",
        props: {hello: "modal"},
        url: "/modal",
        version: "1",
        encryptHistory: false,
        clearHistory: false,
        meta: {
          deferredProps: {
            default: ["deferred_param"],
            custom: ["merge_param"]
          },
          mergeProps: ["merge_param"]
        }
      }
    end

    let(:expected_modal_on_base) do
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
          _inertiaui_modal: expected_modal_on_base
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
        clearHistory: false,
        id: "inertiaui_modal_1234",
        meta: {}
      }
    end

    it "returns page data with base & modal merged together for full-page requests" do
      get "/modal"

      expect(response.status).to eq(200)
      expect(page_data).to eq(expected_page.as_json)
    end

    it "returns base & modal merged together when requested with X-Inertia: true header only" do
      get "/modal", headers: {
        "X-Inertia" => "true",
        "X-Inertia-Version" => "1"
      }

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(expected_page.as_json)
    end

    it "returns modal response when X-InertiaUI-Modal header is present" do
      get "/modal", headers: {
        "X-Inertia" => "true",
        "X-Inertia-Version" => "1",
        "X-InertiaUI-Modal" => "inertiaui_modal_198a8978-df9e-41c5-97ea-cd100651e80e"
      }

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(
        expected_modal.merge(id: "inertiaui_modal_198a8978-df9e-41c5-97ea-cd100651e80e").as_json
      )
    end

    it "returns only deferred props when requested with X-InertiaUI-Modal header" do
      get "/modal", headers: {
        "X-Inertia" => "true",
        "X-Inertia-Version" => "1",
        "X-InertiaUI-Modal" => "inertiaui_modal_1234",
        "X-Inertia-Partial-Component" => "modal",
        "X-Inertia-Partial-Data" => "deferred_param"
      }

      expect(response.status).to eq(200)
      expect(response.parsed_body).to eq(expected_defer_modal.as_json)
    end
  end

  describe "when base URL controller uses implicit rendering" do
    it "returns the rendered response body" do
      get "/implicit_modal"

      expect(response.status).to eq(200)
      expect(page_data).to include("component" => "base")
    end
  end

  describe "when base URL returns another modal" do
    it "renders without infinite recursion" do
      get "/nested_modal"

      expect(response.status).to eq(200)
      page = page_data
      expect(page["component"]).to eq("base_modal")
      expect(page["props"]).to have_key("_inertiaui_modal")
      expect(page["props"]["_inertiaui_modal"]["component"]).to eq("nested_modal")
    end
  end

  describe "resolving base URL" do
    it "prioritizes header over referer and configured base_url" do
      get "/modal_with_base", headers: {
        "X-InertiaUI-Modal-Base-Url" => "/base",
        "Referer" => "http://www.example.com/somewhere_else"
      }

      expect(response.status).to eq(200)
      modal_data = page_data["props"]["_inertiaui_modal"]
      expect(modal_data["baseUrl"]).to eq("/base")
    end

    it "falls back to referer when no header and no configured base_url" do
      get "/modal_no_base", headers: {
        "Referer" => "http://www.example.com/base"
      }

      expect(response.status).to eq(200)
      modal_data = page_data["props"]["_inertiaui_modal"]
      expect(modal_data["baseUrl"]).to eq("http://www.example.com/base")
    end

    it "skips header when it matches current path" do
      get "/modal_with_base", headers: {
        "X-InertiaUI-Modal-Base-Url" => "/modal_with_base",
        "Referer" => "http://www.example.com/base"
      }

      expect(response.status).to eq(200)
      modal_data = page_data["props"]["_inertiaui_modal"]
      expect(modal_data["baseUrl"]).to eq("http://www.example.com/base")
    end

    it "skips referer when it matches current path" do
      get "/modal_with_base", headers: {
        "Referer" => "http://www.example.com/modal_with_base"
      }

      expect(response.status).to eq(200)
      modal_data = page_data["props"]["_inertiaui_modal"]
      expect(modal_data["baseUrl"]).to eq("/base")
    end

    it "returns direct modal when no base URL can be resolved" do
      get "/modal_no_base"

      expect(response.status).to eq(200)
      expect(page_data["component"]).to eq("modal_no_base")
      expect(page_data["props"]).not_to have_key("_inertiaui_modal")
    end

    it "returns direct modal when referer matches current path and no configured base_url" do
      get "/modal_no_base", headers: {
        "Referer" => "http://www.example.com/modal_no_base"
      }

      expect(response.status).to eq(200)
      expect(page_data["component"]).to eq("modal_no_base")
      expect(page_data["props"]).not_to have_key("_inertiaui_modal")
    end

    it "skips configured base_url when it matches current path" do
      get "/modal_self_base"

      expect(response.status).to eq(200)
      expect(page_data["component"]).to eq("modal_self_base")
      expect(page_data["props"]).not_to have_key("_inertiaui_modal")
    end
  end

  describe "when base URL uses other param names" do
    it "receives correct parameters from base URL" do
      get "/projects/789/tasks/456"

      expect(response.status).to eq(200)
    end
  end
end
