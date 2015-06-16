require 'rails_helper'

describe GithubController do

  let!(:repo) { Repository.find_or_create_by(full_name: "jeromegn/documentup") }
  let!(:page) { Page.find_or_create_by(repository: repo, path: '') }

  describe "POST /recompile" do

    context "w/ markdown changes" do
      before { expect_any_instance_of(Page).to receive(:refresh) }
      before { expect_any_instance_of(Repository).not_to receive(:refresh) }
      before { post :push, payload: File.open(File.dirname(__FILE__) + '/../support/fixtures/push_webhook_changes_markdown.json', 'rb').read }
      it { expect(response.body).to be_blank }
      it { expect(response.status).to eq(200) }
    end

    context "w/ config changes" do
      before { expect_any_instance_of(Page).not_to receive(:refresh) }
      before { expect_any_instance_of(Repository).to receive(:refresh) }
      before { post :push, payload: File.open(File.dirname(__FILE__) + '/../support/fixtures/push_webhook_changes_config.json', 'rb').read }
      it { expect(response.body).to be_blank }
      it { expect(response.status).to eq(200) }
    end

    context "w/ both markdown and config changes" do
      before { expect_any_instance_of(Page).to receive(:refresh) }
      before { expect_any_instance_of(Repository).to receive(:refresh) }
      before { post :push, payload: File.open(File.dirname(__FILE__) + '/../support/fixtures/push_webhook_changes.json', 'rb').read }
      it { expect(response.body).to be_blank }
      it { expect(response.status).to eq(200) }
    end

    context "w/o relevant changes" do
      before { expect_any_instance_of(Page).not_to receive(:refresh) }
      before { expect_any_instance_of(Repository).not_to receive(:refresh) }
      before { post :push, payload: File.open(File.dirname(__FILE__) + '/../support/fixtures/push_webhook_no_changes.json', 'rb').read }
      it { expect(response.body).to be_blank }
      it { expect(response.status).to eq(200) }
    end

  end

end