dotfiles-env
============

My environment-related configuration / dotfiles

This is a [`vcsh`][vcsh]-managed repository for my environment-related
dotfiles. I follow a *grouped* software schema for my dotfiles rather
than software-specific repos (to keep it tidier). If the need arises
later (a particular piece of software deserves its own repo), I will
shift the contents out.

Currently, software/config that I classify under "environment"
includes:

  -	`bash`
  -	`gnome` : note this is being shifted to env-gui
  -	`unity` : ditto
  -	`git`
  - `abcde`

Bash Aliases
------------

Currently I have vim aliased to be launched in a 256 colour terminal
environment (rather than the default xterm). This probably needs to be
replaced by a gnome-terminal custom shell command (as the next softest
option) or an exported TERM variable in my profile as I'm fed up with
other applications opening up Vim in 16 colour mode (like now) because
they don't use my alias.

Secondly, I'd like to implement autocompletion for aliased commands.

A couple I haven't really used much are the `apt-` family of aliases.
They're actually really quite useful when mucking around with package
installations but they suffer from no autocompletion. They are also
not particularly "dangerous" in that muscle memory / learning
shortcuts is not really an issue here like it is with rm -i and other
dangerous aliases.

See [stackexchange](http://unix.stackexchange.com/a/4220).


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
