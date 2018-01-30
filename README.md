# Dockerfile2bash - Convert a Dockerfile to Bash

`Dockerfile2bash` is used to parse a Dockerfile and convert it to a Bash script eventually. Maybe you can use it to convert massive Dockerfiles to shell scripts used in a metal installation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dockerfile2bash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dockerfile2bash

## Usage

```ruby
require 'dockerfile2bash'

parser = Dockerfile2bash.new(<your_Dockerfile_path>)
# parse it at first
parser.parse
# you can check the parse results
puts parser.commands
# then convert it to a Bash script
puts parser.generate_bash
```

### Commandline tool

A command named `df2sh` released with Dockerfile2bash. After installation the command will be available in your shell path.

```bash
df2sh /path/to/your/Dockerfile [output_bash_filename]
```

`out.sh` will be used as output filename in current directory if the `output_bash_filename` is omitted.

And here some example generated scripts: [examples](./examples).

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beijingrb/dockerfile2bash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the dockerfile2bash project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/beijingrb/dockerfile2bash/blob/master/CODE_OF_CONDUCT.md).
