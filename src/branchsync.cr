require "json"

DEBUG = false
DEBUG = true if ENV.has_key?("DEBUG") && ENV["DEBUG"].downcase == "true"

def esc_squot(str : String)
  str = str.to_s
  return "''".dup if str.empty?

  str = str.dup
  str = str.gsub(/([^A-Za-z0-9_\-.,:\/@ ])/, "\\\\\\1")
  return str
end

def run(cmd, args)
  stdout = IO::Memory.new
  process = Process.new(cmd, args, output: stdout)
  status = process.wait
  stdout.to_s
end

def pandoc_rewrap(str)
  input_tempfile = File.tempfile("pre-pandoc-pr.md") do |fh|
    fh.print(str)
  end

  output_tempfile = File.tempfile("pandoc-output.md")

  `pandoc -s #{input_tempfile.path} -o #{output_tempfile.path} --wrap none`

  output = File.read(output_tempfile.path)

  input_tempfile.delete
  output_tempfile.delete

  return output
end

def main
  current_pr = JSON.parse(`gh pr view --json body,title,baseRefName`)
  title = current_pr["title"].as_s
  body = current_pr["body"].as_s
  base = current_pr["baseRefName"].as_s

  commits_on_this_branch = `git log --pretty=oneline #{base}..HEAD`.split("\n").select { |i| i != "" }

  if commits_on_this_branch.size != 1
    puts "Branch syncing only works with one single commit."
    exit 1
  end

  commit_sha = commits_on_this_branch[0].split(" ")[0]
  rev = `git rev-list --format=%B --max-count=1 #{commit_sha}`.split("\n")

  args = [] of String

  new_title = rev[1].strip
  if new_title != title
    args << "-t '#{esc_squot(new_title)}'"
    `gh pr edit -t '#{esc_squot(new_title)}'`
    puts "Changed PR title"
  end

  new_body = nil
  if rev.size > 2
    body_unprocessed = rev[2..].join("\n").strip
    new_body = pandoc_rewrap(body_unprocessed)
  end

  if DEBUG
    puts "Existing body..."
    puts body
    puts "New body..."
    puts new_body
  end

  if !(new_body.nil?) && new_body != body
    puts "Syncing new bodies" if DEBUG
    tempfile = File.tempfile("github_pr_sync") do |file|
      file.print(new_body)
    end
    run("gh", ["pr", "edit", "-F", tempfile.path])
    tempfile.delete
  end
end

main()
