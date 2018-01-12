include_recipe 'cc-webapp-cookbook::hostsfile_entry'
include_recipe 'java'

app_name = node['cc-webapp']['appname']
application_run_as_user = node['cc-webapp']['application_run_as_user'] % {appname: app_name}
install_dir = '/opt/' + app_name

group application_run_as_user do
	action :create
end

user application_run_as_user do
	gid application_run_as_user
	shell '/usr/sbin/nologin'
	system true
	action :create
end

directory install_dir do
	owner 'root'
	group application_run_as_user
	mode '550'
end


config_dir = install_dir + '/config'
directory config_dir do
	owner 'root'
	group application_run_as_user
	mode '550'
end


logging_dir = '/var/log/' + app_name
directory logging_dir do
	owner 'root'
	group application_run_as_user
	mode '770'
end

template config_dir + '/logback-spring.xml' do
	source 'logback-spring.xml.erb'
	owner 'root'
	cookbook node['cc-webapp']['spring_boot_sources_cookbook']
	group application_run_as_user
	mode '640'
end

bin_dir = install_dir + '/bin'
directory bin_dir do
	owner application_run_as_user
	mode '5500'
end


template bin_dir + '/install.sh' do
	source 'spring_boot_install.sh.erb'
	owner 'root'
	mode '0700'
	variables(
		:application_run_as_user => application_run_as_user,
		:app_name => app_name,
		:bin_directory => bin_dir
	)
end

host_name = node['cc-webapp']['hostname']
properties_encryption_key = data_bag_item('credentials', host_name)['properties_encryption_key']

template bin_dir + '/run.sh' do
	source 'spring_boot_run.sh.erb'
	owner 'root'
	group application_run_as_user
	mode '0750'
	variables(
		:app_name => app_name,
		:properties_encryption_key => properties_encryption_key,
		:bin_directory => bin_dir,
		:spring_config_location => config_dir + '/',
		:logging_config_file => config_dir + '/logback-spring.xml',
		:java_options => node['cc-webapp']['tomcat']['java_options']
	)
	sensitive true
end



template '/etc/systemd/system/' + app_name + '.service' do
	source 'spring_boot.service.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables(
		:app_name => app_name,
		:application_run_as_user => application_run_as_user,
		:path_to_executable => bin_dir + '/run.sh'
	)
	notifies :run, 'execute[Load systemd unit file]', :immediately
end

execute 'Load systemd unit file' do
	command 'systemctl daemon-reload'
	action :nothing
end

service app_name + '.service' do
	provider Chef::Provider::Service::Systemd
	action [:enable]
end

include_recipe 'cc-webapp-cookbook::ssl'
include_recipe 'cc-webapp-cookbook::apache_httpd'
