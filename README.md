# git_repo_upgrader

Copy specific files from another git repository into your current project and provide (optional) automatic commits.

Useful for manually integrated files from another git project. Do upgrades by one command.

# Contents

* [Installation](#installation)
* [Usage](#usage)
* [Documentation](#documentation)
* [Contributing](#contributing)




<a name="installation"></a>
## Installation

### Prerequisites
Git must be installed and bin directory must be included in PATH variable.

### Add gem to your ruby project

Add this line to your application's Gemfile:

```ruby
gem 'git_repo_upgrader'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install git_repo_upgrader
    
## Common information

TODO






<a name="usage"></a>
## Usage

At best create a new rake task containing a options hash and then run #upgrade.

See the examples below for option hahes.

### Examples

#### Basic

```ruby
    options = {
        repo: {
            uri: 'https://github.com/username/project.git',
            branch: 'develop',
        },
        files_to_copy: {
            'dist/app.bundle.js' => 'web/js/lib/project/app.bundle.js',
            'dist/app.bundle.css' => 'web/js/lib/project/app.bundle.css',
            # copy a whole directory recursively
            'dist/img' => 'web/js/lib/project/img',
        }
    }
    GitRepoUpgrader.upgrade options
```





<a name="documentation"></a>
## Documentation
Check out the doc at RubyDoc
<a href="https://www.rubydoc.info/gems/git_repo_upgrader">https://www.rubydoc.info/gems/git_repo_upgrader</a>





<a name="contributing"></a>
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/magynhard/git_repo_upgrader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

