# Repo Man

Repo Man is a Rails application for managing source code repositories. Currently, it can create, rename, and destroy Git and Subversion repositories. It also has an API, which works with [Provisional](http://github.com/vigetlabs/provisional) and [Provisional-Repoman](http://github.com/vigetlabs/provisional-repoman) to automate repository management.

## Design Decisions

Repo Man was originally written as a proprietary tool for Viget Labs. At Viget, we keep Git and Subversion repositories on a central server, which all personnel can access. This means that repositories must be set up in a certain way: they must be writable by a shared UNIX group, and permissions on the group must be retained on commit. Furthermore, the repository must be created by the root user in order to set permissions properly.

Prior to Repo Man, we created new repositories using a set of UNIX shell scripts, run under sudo. Since these scripts worked very well for us, and since matters of root access and setgid get tricky in pure Ruby, we decided to have Repo Man continue to use these scripts.

What this means to you, the non-Viget user of Repo Man, is that you will have to write scripts similar to ours to do the actual heavy lifting. Our scripts are included in the `examples` directory. *You will need to adapt these to your site.* In particular, you will probably want to change where the repositories live on the file system, who owns them, or other things that sites typically adjust to taste.

## Security Concerns

*Repo Man is designed to be run in an environment where you trust anyone who could potentially have access to it;* at Viget, it runs inside our company firewall (which, if breached, means we're pretty much toast anyway), and we live by The Repo Code (see `app/views/repositories/index.html.erb`.) In particular, it does not include any authentication, and it depends on the web server user having sudo access to run potentially destructive commands. If the lack of strong security concerns you (and, frankly, it probably should) then Repo Man is not the droid you're looking for. Viget Labs will not take any responsibility for anything happening as a result of you using Repo Man, so please be careful.

## Requirements

You'll need a UNIX or UNIX-like server to run Repo Man. This server should have your preferred Ruby on Rails frontend stack (we use Apache with Passenger), access to a database, sudo, and your repository-creating scripts mentioned in the last section.

Repo Man requires Rails 2.3. If you remove the frozen `vendor/rails` directory for any reason, make sure you have Rails 2.3 available in some other way.

In the `config` directory, you'll need to copy or rename `database.yml-sample` and `site.yml-sample` to remove the `-sample` suffix. `database.yml` is just like any other Rails app, but `site.yml` deserves some explanation:

* `git_host`: The host where your Git repositories reside. It should permit ssh connections for all developers.
* `git_root`: The directory on `git_host` where the Git repositories reside.
* `git_script`: The script you use to create Git repositories.
* `svn_host`: The host where your Subversion repositories reside. It should be running `svnserve`.
* `svn_root`: The directory on `svn_host` where the Subversion repositories reside.
* `svn_script`: The script you use to create Subversion repositories.

Be sure that the user running the web server has sudo rights to run your scripts, as well as the `rm` and `mv` commands:

    # in /etc/sudoers
    apache ALL=NOPASSWD: /usr/local/bin/git-o-mat.sh
    apache ALL=NOPASSWD: /usr/local/bin/svn-o-mat.sh
    apache ALL=NOPASSWD: /bin/rm
    apache ALL=NOPASSWD: /bin/mv

## Limitations

Repo Man repositories, once created, can only be modified in certain ways:

* If the name of the repository is changed, the repository will also be renamed on disk, and its path updated accordingly.
* You cannot change the scm type of a repository once it's been created. This is way beyond the scope or ability of Repo Man.

Repo Man manages the path attribute of repositories, hence why it is not mass-assignable. *Do not directly/manually change the path of a repository unless you know what you are doing.* Change the name instead, and the path will be adjusted to match.

## The API

Repo Man exposes an API that can be accessed via Active Resource. See `/app/views/api/index.html.erb` for some examples.

## Movie References

There are references to Alex Cox's _Repo Man_ throughout the application. See if you can spot them all! The first person to spot them all wins absolutely *nothing.*

If you have the [Rockwell font](http://www.fonts.com/findfonts/detail.asp?pid=201908) installed on your system, the views will resemble the generic products previously sold at Ralph's, as seen in the _Repo Man_ movie. If you do not have the Rockwell font, a sans-serif font (typically Helvetica or Arial) will be used, making the views resemble Public Image Ltd.'s _Album_.

## Author/License

Repo Man was written by [Mark Cornick](http://github.com/mcornick). It is provided to you under the MIT license.
