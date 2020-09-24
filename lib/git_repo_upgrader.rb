require 'date'
require 'colorize'
require 'pathname'
require 'tmpdir'

require 'git_repo_upgrader/version'

#
# GitRepoUpgrader
#
# Checkout a git repository to a temporary directory 
# and extract specific files from there into your project
#
# Example:
#
#       options = {
#           repo: {
#               uri: 'https://github.com/username/project.git',
#               branch: 'develop',
#           },
#           files_to_copy: {
#               'dist/app.bundle.js' => 'web/js/lib/project/app.bundle.js',
#               'dist/app.bundle.css' => 'web/js/lib/project/app.bundle.css',
#               # copy a whole directory recursively
#               'dist/img' => 'web/js/lib/project/img',
#           }
#       }
#       GitRepoUpgrader.upgrade options
#
#

module GitRepoUpgrader

  TMP_DIR_PREFIX = 'GitRepoUpgrader_'
  PROJECT_DIR = Dir.pwd
  GIT_REPO_NAME_REGEX = /\/([^\/]+).git/

  # @param [Hash] options
  def self.upgrade(options)
    puts '*****************************'.yellow
    puts '** Git Repo Upgrader'.yellow
    puts '*****************************'.yellow
    repo_dir, tmp_dir = _checkout_git_repo options[:repo][:uri], options[:repo][:branch]
    _copy_files_from_checkout repo_dir, options[:files_to_copy]
    _cleanup_checkout tmp_dir
    repo_name = options[:repo][:uri].match(GIT_REPO_NAME_REGEX)[1]
    _commit_files options[:files_to_copy], repo_name
    puts
    puts "Everything done, be happy! :-) ".magenta
  end

  private

  # @param [String] github source path
  # @param [String] branch
  # @return [String] path to repo dir
  def self._checkout_git_repo(source, branch)
    print ' - creating tmp dir ... '
    Dir.chdir Dir.tmpdir
    tmp_dirname = TMP_DIR_PREFIX + Time.now.to_i.to_s
    Dir.mkdir(tmp_dirname)
    print tmp_dirname + ' ... '
    Dir.chdir tmp_dirname
    puts 'done'.green
    begin
      puts ' - checkoutA repository ' + source + " (#{branch}) ... "
      git_command = "git clone --single-branch --branch #{branch} #{source}"
      puts '   ' + git_command.blue
      git_result = system(git_command)
      raise "invalid username or password" unless git_result
    rescue RuntimeError => e
      puts e.to_s.red
      retry
    end
    puts '   done'.green
    puts
    repo_dir = Dir['*'].first
    [File.expand_path(repo_dir), tmp_dirname]
  end


  def self._copy_files_from_checkout(repo_dir, files_to_copy)
    Dir.chdir repo_dir
    puts ' - copy repo files ... '
    files_to_copy.each do |source, dest|
      puts "   #{source} -> " + " #{dest}".green
      final_dest = PROJECT_DIR + '/' + dest
      # remove last folder from path, because FileUtils.cp_r creates the last folder in dest implicitly
      final_dest = final_dest[0...-1] if final_dest.end_with? '/' # cut / at the end if available
      final_dest = Pathname(final_dest).dirname.to_s # cut last folder
      FileUtils.cp_r(repo_dir + '/' + source, final_dest)
    end
  end

  def self._cleanup_checkout(tmp_dir)
    print ' - remove tmp dir ... '
    Dir.chdir Dir.tmpdir
    FileUtils.rm_rf tmp_dir
    puts 'done'.green
  end

  def self._commit_files(files, repo_name)
    puts
    default_input = 'y'
    yes_no = nil
    loop do
      print "Commit the copied files above? (y/n) [#{default_input}]:".yellow
      yes_no = STDIN.gets.chomp
      yes_no = default_input if yes_no == ''
      if yes_no == '' || !(['y', 'n'].include? yes_no)
        puts "Invalid option '#{yes_no}'".red
      else
        break
      end
    end
    if yes_no == 'y'
      Dir.chdir PROJECT_DIR
      # add
      git_commit_command1 = %Q(git add "#{files.values.join('" "')}")
      puts "   #{git_commit_command1}".blue
      git_result1 = `#{git_commit_command1}`
      # commit
      git_commit_command2 = %Q(git commit "#{files.values.join('" "')}" -m "upgrade #{repo_name}")
      puts "   #{git_commit_command2}".blue
      git_result2 = `#{git_commit_command2}`
      if git_result2.include? 'no changes added to commit'
        puts
        puts "   You already had the latest version, nothing to commit!".red
      else
        puts git_result2.green
      end
    end
  end

end
