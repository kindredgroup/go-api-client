require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run all tests"
Rake::TestTask.new do |t|
   t.libs << "test"
   t.test_files = FileList['test/**/*test.rb']
   t.verbose = true
 end

desc "upload the gem to artifact repository"
task :upload do
  go_artifact_repository_parent = ENV['ARTIFACT_REPO_PARENT'] || Dir.home
  go_artifact_repository_name   = ENV['ARTIFACT_REPO_NAME'] || "go-api-client-artifact"
  go_artifact_repository_path   = go_artifact_repository_parent + "/" + go_artifact_repository_name

  ssh_key_path = File.expand_path("../ssh_keys/git-ci.zeroci.com",__FILE__)
  git_ssh_path = File.expand_path("../ssh_keys/git-ssh",__FILE__)

  artifact_repository_host = "ec2-184-72-152-107.compute-1.amazonaws.com"
  artifact_repository_user = "git"

  commit_msg = "New Artifact"
  sh "chmod 0400 #{ssh_key_path}"
  if !File.exists?(go_artifact_repository_path)
    clone_cmd = "GIT_SSH=#{git_ssh_path} git clone #{artifact_repository_user}@#{artifact_repository_host}:#{go_artifact_repository_name}"
    sh "cd #{go_artifact_repository_parent} && #{clone_cmd}"
  end

    sh "bundle exec rake build"
    sh "cp pkg/* #{go_artifact_repository_path}"
    sh "cd #{go_artifact_repository_path} && git add ."
    sh "cd #{go_artifact_repository_path} && git commit -m\'#{commit_msg}\'"
    push_cmd = "GIT_SSH=#{git_ssh_path} git push origin master"
    sh "cd #{go_artifact_repository_path} && #{push_cmd}"
  end

desc "the default task"
task :default => :test