# branchsync

branchsync seeks to solve a boring but simple problem faced by the working
developer.

1. You write some code on a branch.

2. You push that branch up to a Git host (GitHub, GitLab, etc.). If you're
   using GitHub, this means you've reformatted your commit message from being
   split on 74/80-ish lines because otherwise your newlines get preserved in the
   HTML that gets outputted because GitHub doesn't follow the spec.
   (see [§6.8 CommonMark](https://spec.commonmark.org/0.30/#soft-line-breaks))

3. You create a pull request, merge request or whatever the equivalent is
   called.

4. You work on that code some more, and modify the commit message. (You're
   rebasing and ensuring everything's one commit, right?)

5. Now your pull request is out-of-sync with the commit message. The single
   source of truth becomes multiple sources of irritation.

It does this by automating a process that is often done manually by developers,
and then shelling out to the various command line utilities (e.g. `gh` for
GitHub and `pandoc`).

## Installation

You'll need `gh` (the [GitHub CLI](https://cli.github.com/)) and
[Pandoc](https://pandoc.org/) installed. And `git` obviously, but that should
be fairly self-apparent.

Currently, you'll need to manually compile branchsync. At some point, we can
set up CI to cross-compile new releases.

## Usage

Currently, you just run `branchsync`. If there's a problem, it should fail out
with a fairly self-explanatory error.

## Development

If you want to see what the code is doing, set the `DEBUG` environment variable
to the string 'true'.

The code is not pleasant, it's hacky and built to do the job and no more.

It's Crystal because it is a reasonably nice way to write something high level
but also compiles down to a single binary.

There are lots of things to do. For instance:

- tests
- CI and cross-compile
- refactor to support multiple providers (e.g. GitLab)
- auto-strip [trailers](https://git-scm.com/docs/git-interpret-trailers)
  like `Co-authored-by` and `Signed-off-by` (either all of them, or known ones)
- user-specific config stored (preferably in conformity with the XDG spec, preferably TOML?)

## Contributing

1. Fork it (<https://github.com/tommorris/branchsync/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
