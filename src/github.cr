module GitHub
  extend self

  def get_current_pr
    current_pr = JSON.parse(`gh pr view --json body,title,baseRefName`)
    title = current_pr["title"].as_s
    body = current_pr["body"].as_s
    base = current_pr["baseRefName"].as_s

    return { current_pr, title, body, base }
  end

  def change_title(new_title)
    `gh pr edit -t '#{esc_squot(new_title)}'`
  end
end
