# Class: bashrc

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bashrc](#setup)
    * [What bashrc affects](#what-bashrc-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with bashrc](#beginning-with-bashrc)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

This class manages additions to bashrc system-wide. This facilitates a means to run a pre-defermined list of scripts which are fed data derived from puppet for all users on the system.

#### Currently implemented functionality:
* The ability to dynamically alter the colors of the user's prompt depending on hiera parameters.
* the ability to enable git integration with your tab completion
* the ability to customize the left and right sides of the prompt.
* The ability to display git branch statistics for the current branch

#### Work-In-Progress functionality:
* The ability to feed a script a list of servicenames, and their corresponding processnames to report the status, and number of processes at login.
* The ability to feed a script a list of portnames, protocol, port number, and detail level to report on at login
* The ability to feed a script a list of repositories, and their corresponding filesystem path. it can report the branch and status of the repository found at that location
  * GIT
  * bzr
  * svn
  * hg


## Setup

### What bashrc affects
* **Directories**:
  * /etc/profile.d
* **Files**: `templated files are displayed like this`
  * `/etc/bashrc`
  * `/etc/profile.d/prompt.sh`
  * /etc/profile.d/git_completion.sh
  * /etc/profile.d/git_prompt.sh
  * `/usr/local/etc/svcstat.conf`
  * /usr/local/bin/svcstat.py
  * `/etc/profile.d/svcstat.sh`

### Setup Requirements
 * **Required Classes**
   * stdlib

### Beginning with bashrc

* `include bashrc`

## Usage

This module is intended to be a foundation which can accept other extensions. Each piece of functionality is enabled or disabled in topscope, which inherits its' parameter values from class topscope.

Each submodule has default values in **bashrc::config**.

**bashrc::setup** is reponsible for the alterations to `/etc/bashrc` and the creation of `/etc/profile.d`

**bashrc::prompt** is responsible for prompt customizations like enabling or disabling and changing the colorization, enabling git branch awareness and enhancements.


### Hiera Example for example profile module

    profile::bashrc::enable_git_completion:  true
    profile::bashrc::enable_prompt_color:    true
    profile::bashrc::enable_prompt_mods:     true
    profile::bashrc::enable_svcstat:         true
    profile::bashrc::prompt_git_color:       'cyan'
    profile::bashrc::prompt_git_enable:      true
    profile::bashrc::prompt_leftblock:       '\u'
    profile::bashrc::prompt_primary_color:   'blue'
    profile::bashrc::prompt_rightblock:      '\h \W'
    profile::bashrc::prompt_secondary_color: 'green'
    profile::bashrc::prompt_separator:       '@'
    profile::bashrc::svcstat_hash:
      apache: {
        name:   'Apache',
        string: 'apache2'
      }
### Parameters

* **bashrc** Class
  * **bashrcdir** *absolute path*

  Sets the location of the directory to place our rcscripts. Set to /etc/profile.d for most Linux distros.
  * **enable_git_completion** *boolean*

  Whether or not to deploy the git completion script to integrate git into tab awareness
  https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
  * **enable_prompt_color** *boolean*

  Whether or not to enable colorization of the shell prompt
  * **enable_prompt_mods** *boolean*

  Whether or not to put ps1 under puppet control
  * **enable_svcstat** *bool*

  Whether or not to enable the [svcstat](https://github.com/wolfspyre/python-svcstat) script. *default: true*
  * **enable_prompt_color** *boolean*

  Whether or not to enable the colorization of the shell prompt
  * **prompt_git_color** *string*

  The color to display the git branch in. Supported options: ** red , green , yellow , blue , purple , cyan , white**
  * **prompt_git_enable** *boolean*

  Whether or not to display git info of the working directory in the prompt
  * **prompt_leftblock** *string*

  What to set the left side of the prompt to. Reference the [TLDP bash PS1 variable guide](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html) for inspiration
  * **prompt_primary_color** *string*

  What color the left portion of the prompt should be. Supported options: ** red , green , yellow , blue , purple , cyan , white**
  * **prompt_rightblock** *string*

  What to set the right side of the prompt to. Reference the [TLDP bash PS1 variable guide](http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html) for inspiration
  * **prompt_secondary_color** *string*

  What color the right portion of the prompt should be. Supported options: ** red , green , yellow , blue , purple , cyan , white**
  * **prompt_separator** *string*

  The character(s) used to separate the left side of the prompt from the right. `default: '@'`
  * **puppetdir** *string*
  Sets where puppet is installed by default. Necessary for template switcher via an inline template
  * **svcstat_hash** *hash of hashes*/undef

  for each key/value pair contained within this hash, a line will be added to the /usr/local/etc/svcstat.conf file. The keys are:
    * **name** This is the pretty name displayed for the service.
    * **string** The string to search the process tree for to determine if the service is running.
* **bashrc::prompt** class

* **bashrc::setup** Class

* **bashrc::svcstat** Class
  * **binpath**    *absolute path* **default value:`/usr/local/bin`**

  The path to place svcstat.py. This should not need to be changed.
  * **configpath** *absolute path* **default value:'/usr/local/etc/svcstat.conf'

  The path to lay down the configfile for svcstat. This should not need to be changed.

## Requirekments
  * [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)

## Reference

## Limitations


## Development
Wolf Noble <wolf@wolfspyre.com>

### Contributions

Please fork this project, add your improvements, and submit a pull request. This way, we'll all get better tools
### svcstat.py
  * Please contribute to [svcstat.py here](https://github.com/wolfspyre/python-svcstat)
