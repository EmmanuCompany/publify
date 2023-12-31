# frozen_string_literal: true

require "rails_helper"

RSpec.describe "xml_sidebar/_content.html.erb", type: :view do
  let(:sidebar) { XmlSidebar.new }

  context "by default" do
    before do
      render partial: sidebar.content_partial, locals: sidebar.to_locals_hash
    end

    it "renders a link to the articles feed" do
      expect(rendered).to have_css("a[href='#{articles_feed_path(format: "atom")}']")
    end

    it "renders a link to the feedback feed" do
      expect(rendered).to have_css("a[href='#{feedback_index_path(format: "atom")}']")
    end
  end

  context "on an article page" do
    before do
      allow(controller).to receive_messages(controller_name: "articles",
                                            action_name: "redirect")
      @article = create(:article)
      render partial: sidebar.content_partial, locals: sidebar.to_locals_hash
    end

    it "renders a link to the article comments feed" do
      expect(rendered).to have_css("a[href='#{@article.feed_url("atom")}']")
    end
  end

  context "on a tags page" do
    before do
      sidebar.tag_feeds = true
      allow(controller).to receive_messages(controller_name: "tags", action_name: "show")
      @tag = create(:tag)
      @auto_discovery_url_atom = "foofoo"
      render partial: sidebar.content_partial, locals: sidebar.to_locals_hash
    end

    it "renders a link to the tag feed" do
      expect(rendered).to have_css("a[href='#{@tag.feed_url("atom")}']")
    end
  end
end
