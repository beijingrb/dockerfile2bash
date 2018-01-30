require 'json'

class Dockerfile2bash
  VERSION = '0.1.1'
  attr_reader :commands
  FIELDS = %w(from user run add copy arg env expose cmd onbuild)

  def initialize(dockerfile)
    @dockerfile = dockerfile
    @content = File.read(@dockerfile)
    @commands = []
  end

  def parse
    @content.gsub!("\\\n", "")
    lines = @content.split(/\r?\n+/) || []

    lines.each do |ln|
      # ignore blank and comment lines
      next if /^\s*$/ =~ ln
      next if /^\s*#/ =~ ln
      segments = ln.split(" ", 2)
      next if segments.length < 2 or !FIELDS.include?(segments[0].downcase)

      case segments[0].downcase!
      when "from", "user", "run", "env", "expose", "copy", "add"
        @commands << { segments[0] => segments[1] }
      when "cmd"
        @commands << { "cmd" => (JSON.parse(segments[1]) || []).join(" ") }
      when "arg"
        args = segments[1].split("=", 2)
        if args.length == 2
          @commands << { "arg" => args }
        end
      end
    end
    @commands
  end

  def generate_bash()
    return unless @commands
    bash = "#!/bin/bash \n\n# The script is generated from a Dockerfile via Dockerfile2bash(v#{VERSION})\n# By B1nj0y <idegorepl@gmail.com>\n\n"
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
        bash << "echo \"#{env_str}\" >> ~/.bashrc" << "\n"
      end
    end
    bash
  end
end
