# private class
class mcollective::server::config::factsource::yaml_cron {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  cron{'generate-mcollective-yaml':
    minute  => '*/15',
    command => "facter -p -y > ${mcollective::yaml_fact_path}"
  }

  file { $mcollective::yaml_fact_path:
    ensure => 'file',
    owner  => 'root',
    group  => '0',
    mode   => '0400',
  }

  mcollective::server::setting { 'factsource':
    value => 'yaml',
  }

  mcollective::server::setting { 'plugin.yaml':
    value => $mcollective::yaml_fact_path,
  }
}
