require 'json'
require 'rest-client'

class Dockerfile2bash
  attr_reader :commands
  attr_accessor :content

  VERSION = '0.1.5'
  FIELDS = %w(from user run add copy arg env expose cmd onbuild)

  def initialize(dockerfile)
    @dockerfile = dockerfile
    @content = get_content
    @commands = []
  end

  def parse
    return if !@content || @content.empty?
    @content.gsub!("\\\n", "")
    lines = @content.split(/\r?\n+/) || []

    lines.each do |line|
      # ignore blank and comment lines
      next if /^\s*$/ =~ line
      next if /^\s*#/ =~ line
      segments = line.split(" ", 2)
      next if segments.length < 2 || !FIELDS.include?(segments[0].downcase)

      case segments[0].downcase!
      when "from", "user", "run", "expose", "copy", "add"
        @commands << { segments[0] => segments[1] }
      when "cmd"
        @commands << { "cmd" => (JSON.parse(segments[1]) || []).join(" ") }
      when "arg"
        args = segments[1].split("=", 2)
        if args.length == 2
          @commands << { "arg" => args }
        end
      when "env"
        if segments[1] =~ /^[a-zA-Z_].[a-zA-Z0-9_]+?=("|')[^"']*?\1$/
          @commands << { "env" => segments[1] }
          next
        end

        envs = segments[1].split
        pattern = %r/^[a-zA-Z_].[a-zA-Z0-9_]+?=.+$/
        case envs.length
        when 1
          @commands << { "env" => segments[1] }
        when 2
          if envs.all? { |e| e =~ pattern }
            @commands << { "env" => segments[1] }
          else
            @commands << { "env" => envs.join("=") }
          end
        else
          if envs.all? { |e| e =~ pattern }
            @commands << { "env" => segments[1] }
          else
            @commands << { "env" => [envs[0], "\"#{envs[1..-1].join(" ")}\""].join("=") }
          end
        end
      end
    end
    @commands
  end

  def generate_bash()
    return unless @commands
    bash = "#!/usr/bin/env bash \n\n# The script is generated from a Dockerfile via Dockerfile2bash(v#{VERSION})\n# By B1nj0y <idegorepl@gmail.com>\n\n"
    @commands.each do |cmd|
      case cmd.keys[0]
      when "from"
        bash << "# The original Dockerfile is from a base image: <#{cmd["from"]}> \n\n"
      when "run"
        bash << cmd["run"] << "\n"
      when "arg"
        bash << cmd["arg"].join("=") << "\n"
      when "env"
        env_str = "export " << cmd["env"]
        bash << env_str << "\n"
        bash << "echo \'#{env_str}\' >> ~/.bashrc" << "\n"
      end
    end
    bash
  end

  def get_content
    if @dockerfile =~ /^https:\/\/raw\.githubusercontent\.com\/.+$/
      content = RestClient.get(@dockerfile)
    elsif @dockerfile =~ /^https:\/\/github\.com\/(.+)$/
      # convert to its corresponding raw url
      url = "https://raw.githubusercontent.com/#{$1.sub('/blob/', '/')}"
      content = RestClient.get(url)
    else
      # local file
      content = File.read(@dockerfile)
    end
    content
  end
end
