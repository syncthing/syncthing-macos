## Reporting Bugs

Please file bugs in the [Github Issue
Tracker](https://github.com/syncthing/syncthing-macos/issues). Include at
least the following:

 - What happened

 - What did you expect to happen instead of what *did* happen, if it's
   not crazy obvious

 - What operating system, operating system version and version of
   Syncthing you are running

 - The same for other connected devices, where relevant

 - Screenshot if the issue concerns something visible in the GUI

 - Console log entries, where possible and relevant

If you're not sure whether something is relevant, erring on the side of
too much information will never get you yelled at. :)

## Contributing Code

Every contribution is welcome. If you want to contribute but are unsure
where to start, any open issues are fair game! Feel free to open a github issue
 if you have an idea so we can discuss.

### Branches

We use a semi-derived [gitflow](https://datasift.github.io/gitflow/IntroducingGitFlow.html).

* `master` is the mainline where only releases are available
* `develop` is the main branch containing good code that will end up in the next release. You should base your work on it. It won’t ever be rebased or force-pushed to.
* `feature/issue-<id>` are branches which have an issue (or feature) ticket in the Github issue tracker. This is a convention to see which branch is part of which issue.
* Other branches are probably topic branches and may be subject to rebasing. Don’t base any work on them unless you specifically know otherwise.

## Licensing

All contributions are made available under the same license as the already
existing material being contributed to. For most of the project and unless
otherwise stated this means MIT, but there are exceptions:

- Dependencies under Pods/... are copyright by and licensed from their
  respective original authors. Contributions should be made to the original
  project, not here.

Regardless of the license in effect, you retain the copyright to your
contribution.

