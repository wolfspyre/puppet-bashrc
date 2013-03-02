System-wide Bashrc tweaks
======================

 === Parameters

  [*bashrc::params::bashrcdir*]
   Sets the location of the to be created rc directory

  [*bashrc::params::prompt_color_enable*]
   Whether or not to enable the colorization of the shell prompt

  [*bashrc::params::prompt_primary_color*]
   What color the first colorized portion of the prompt should be

  [*bashrc::params::prompt_secondary_color*]
   What color the second colorized portion of the prompt should be

  [*bashrc::params::puppetdir*]
   Sets where puppet is installed by default. Necessary for template switcher via an inline template

  [*bashrc::params::skelfile*]
   Sets the location of the skeleton .bashrc file for new users

  === Variables

 Hiera varibles example:

    bashrc_prompt_color_enable:    'enabled'
    bashrc_prompt_primary_color:   'blue'
    bashrc_prompt_secondary_color: 'red'
    bashrc_prompt_pci_switch:       false

  === Information

 -  [github](https://github.com/wolfspyre/puppet-bashrc) is where to go to collaborate or suggest improvements.

 -  This module is available on [Puppet Forge](http://forge.puppetlabs.com/wolfspyre/bashrc)

Please submit [issues](https://github.com/wolfspyre/puppet-bashrc/issues)
