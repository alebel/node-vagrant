# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  <% _.forEach(config.vm, function(value, key) { %>
  config.vm.<%=key%> = "<%=value%>"
  <% }); %>

  <% if(typeof config.network !== 'undefined') { %>
  config.vm.network "<%= config.network.type %>"<% _.forEach(config.network.detail, function(value, key) { %>, <%= key %>: <% if(typeof value === 'string') { %>"<%=value%>"<% } else { %><%=value%><% } %><% }); %>
  <% } %>

  <% if(typeof config.multimachine !== 'undefined') { %>
  <% _.forEach(config.multimachine, function(machine) { %>
  config.vm.define "<%= machine.name %>"<%=
                                            (!!machine.isPrimary ? ', primary: true' : '') %><%=
                                            (typeof machine.autostart === 'undefined' ? '' :
                                                (', autostart: ' + (!!machine.autostart ? 'true' : 'false'))) %> do |<%= machine.name %>|
<% _.forEach(machine.commands, function(command) {
%>    <%= machine.name %>.<%= command %><% }) %>
  end
  <% }) %>
  <% } %>

  <% if(typeof config.providers !== 'undefined') { %>
  <% _.forEach(config.providers, function(settings, provider) { %>
  config.vm.provider "<%= provider %>" do |<%= provider %>|
    <% _.forEach(settings, function(value, name) { %>
    <%= provider %>.<%= name %> = <%= value %>
    <% }); %>
  end
  <% }); %>
  <% }; %>

  <% _.forEach(config.provisioners, function(provisioner) { %>
  config.vm.provision "<%= provisioner.type %>" do |<%= provisioner.name %>| <% _.forEach(provisioner.templateLines, function(line) { %>
    <%= line %><% }) %>
  end
  <% }) %>
end
