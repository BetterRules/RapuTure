# frozen_string_literal: true

module GithubService
  def self.git_branch
    'master'
  end

  def self.git_clone
    Rails.logger.info("Cloning #{clone_url} into #{git_clone_folder}")
    g = Git.clone(clone_url, git_clone_folder)
    g.checkout(git_branch)
  end

  def self.git_pull
    Rails.logger.info("Pull branch #{git_branch}")
    g = Git.init(git_clone_folder)
    g.checkout(git_branch)
    g.pull
  end

  def self.clone_or_pull_git_repo
    raise if clone_url.blank?

    if File.directory?(git_clone_folder)
      git_pull
    else
      git_clone
    end
  end

  def self.git_clone_folder
    "./tmp/#{ENV['RAILS_ENV']}-openfisca-aotearoa"
  end

  def self.clone_url
    ENV['OPENFISCA_GIT_CLONE_URL']
  end

  def self.yaml_folder(openfisca_folder)
    "#{git_clone_folder}/openfisca_aotearoa/#{openfisca_folder}/" unless openfisca_folder.nil?
  end
end
