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
  * /etc/bashrc.d
* **Files**: `templated files are displayed like this`
  * `/etc/bashrc`
  * `/etc/bashrc.d/prompt.sh`
  * /etc/bashrc.d/git_completion.sh`
  * /etc/bashrc.d/git_prompt.sh

### Setup Requirements
 * **Required Classes**
   * stdlib

### Beginning with bashrc

* `include bashrc`

## Usage

This module is intended to be a foundation which can accept other extensions. Each piece of functionality is enabled or disabled in topscope, which inherits its' parameter values from class topscope.

Each submodule has default values in **bashrc::config**.

**bashrc::setup** is reponsible for the alterations to `/etc/bashrc` and the creation of `/etc/bashrc.d`

**bashrc::prompt** is responsible for prompt customizations like enabling or disabling and changing the colorization, enabling git branch awareness and enhancements.


### Hiera Example
    bashrc::bashrcdir:              '/etc/bashrc.d'
    bashrc::enable_git_completion:  true
    bashrc::enable_prompt_mods:     true
    bashrc::prompt_color_enable:    true
    bashrc::prompt_git_color:       true
    bashrc::prompt_git_enable:      true
    bashrc::prompt_primary_color:   blue
    bashrc::prompt_secondary_color: red
    bashrc::prompt_leftblock:       '\u'
    bashrc::prompt_rightblock:      '\h \W'
    bashrc::prompt_separator:       '@'
    bashrc::prompt_pci_switch:      true
### Parameters

* **bashrc** Class
  * **bashrcdir** *string*

  Sets the location of the to be created rc directory
  * **enable_prompt_mods** *boolean*

  Whether or not to put ps1 under puppet control
  * **enable_git_completion** *boolean*

  Whether or not to deploy the git completion script to integrate git into tab awareness  
  https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
  * **prompt_color_enable** *boolean*

  Whether or not to enable the colorization of the shell prompt
  * **prompt_git_color** *string*
  * **prompt_git_enable** *boolean*

  Whether or not to display git info of the working directory in the prompt
  * **prompt_primary_color** *string*

  What color the left portion of the prompt should be
  * **prompt_secondary_color** *string*

  Whether to prepend 'PCI-' to bashrc::prompt_rightblock (for pci compliant machines)
  * **prompt_pci_switch** *boolean*

  What color the right portion of the prompt should be
  * **puppetdir** *string* Supported options: ** red , green , yellow , blue , purple , cyan , white**

  Sets where puppet is installed by default. Necessary for template switcher via an inline template
  * **skelfile** *string*

  Sets the location of the skeleton .bashrc file for new users
* **bashrc::prompt** class


## Reference

## Limitations

## Development
Wolf Noble <wolf@wolfspyre.com>
