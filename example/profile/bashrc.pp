# Class profile::bashrc
#
class profile::bashrc(
  $enable_git_completion  = hiera('profile::bashrc::enable_git_completion'),
  $enable_prompt_mods     = hiera('profile::bashrc::enable_prompt_mods'),
  $enable_svcstat         = hiera('profile::bashrc::enable_svcstat'),
  $enable_prompt_color    = hiera('profile::bashrc::enable_prompt_color'),
  $prompt_git_color       = hiera('profile::bashrc::prompt_git_color'),
  $prompt_git_enable      = hiera('profile::bashrc::prompt_git_enable'),
  $prompt_leftblock       = hiera('profile::bashrc::prompt_leftblock'),
  $prompt_primary_color   = hiera('profile::bashrc::prompt_primary_color'),
  $prompt_rightblock      = hiera('profile::bashrc::prompt_rightblock'),
  $prompt_secondary_color = hiera('profile::bashrc::prompt_secondary_color'),
  $prompt_separator       = hiera('profile::bashrc::prompt_separator'),
  $purge_bashrcdir        = hiera('profile::bashrc::purge_bashrcdir'),
  $svcstat_hash           = hiera('profile::bashrc::svcstat_hash'),
  ){
  class {'::bashrc':
    enable_git_completion  => $enable_git_completion,
    enable_prompt_mods     => $enable_prompt_mods,
    enable_svcstat         => $enable_svcstat,
    enable_prompt_color    => $enable_prompt_color,
    prompt_git_color       => $prompt_git_color,
    prompt_git_enable      => $prompt_git_enable,
    prompt_leftblock       => $prompt_leftblock,
    prompt_primary_color   => $prompt_primary_color,
    prompt_rightblock      => $prompt_rightblock,
    prompt_secondary_color => $prompt_secondary_color,
    prompt_separator       => $prompt_separator,
    purge_bashrcdir        => $purge_bashrcdir,
    svcstat_hash           => $svcstat_hash,
  }
}
