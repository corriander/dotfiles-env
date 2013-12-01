env-config
==========

This is a [`vcsh`][vcsh]-managed repository for my environment-related
dotfiles. I follow a *grouped* software schema for my dotfiles rather
than software-specific repos (to keep it tidier). If the need arises
later (a particular piece of software deserves its own repo), I will
shift the contents out.

Currently, software/config that I classify under "environment"
includes:

  -	`bash`
  -	`gnome`
  -	`unity`
  -	`git`
  - `abcde`

Special Considerations
----------------------

I don't have my *entire* functional `git` config in this repository.
Purely for pedantic reasons, I have my identity set in a
`.gitidentity` file included by `.gitconfig`. My identity is kept
separate (in a private repo) purely because it's a convenient way to
avoid exposing my email address in plain text unnecessarily without
writing an obfuscation filter, also avoids the edge case where it
accidentally gets adopted by someone not me. This is definitely an
edge case, I doubt this is useful to anyone but me... ;)

[vcsh]: https://github.com/RichiH/vcsh
