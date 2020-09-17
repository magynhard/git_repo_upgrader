require "spec_helper"

RSpec.describe GitRepoUpgrader do
  it "has a version number" do
    expect(GitRepoUpgrader::VERSION).not_to be nil
  end
end

RSpec.describe GitRepoUpgrader, '#upgrade' do
  context 'retrieving specific files from git repository' do

    it 'retrieves files' do
      # TODO
    end

  end
end

RSpec.describe GitRepoUpgrader, '#_checkout_git_repo' do
  context 'checkout git repo' do
    it 'can checkout from github' do
      # TODO
    end
    it 'can checkout from gitlab' do
      # TODO
    end
  end
end