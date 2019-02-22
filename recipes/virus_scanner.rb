package 'clamav-daemon'


template '/lib/systemd/system/clamav-daemon.service' do
	source 'clamav-daemon.service.erb'
	owner 'root'
	group 'root'
	mode '644'
end

template '/lib/systemd/system/clamav-daemon.socket' do
	source 'clamav-daemon.socket.erb'
	owner 'root'
	group 'root'
	mode '644'
end

template '/lib/systemd/system/clamav-daemon-wait.path' do
	source 'clamav-daemon-wait.path.erb'
	owner 'root'
	group 'root'
	mode '644'
end

template '/lib/systemd/system/clamav-daemon-wait.service' do
	source 'clamav-daemon-wait.service.erb'
	owner 'root'
	group 'root'
	mode '644'
end

template '/lib/systemd/system/clamav-socket-wait.path' do
	source 'clamav-socket-wait.path.erb'
	owner 'root'
	group 'root'
	mode '644'
end

template '/lib/systemd/system/clamav-socket-wait.service' do
	source 'clamav-socket-wait.service.erb'
	owner 'root'
	group 'root'
	mode '644'
end


directory '/etc/systemd/system/clamav-daemon.socket.d' do
	owner 'root'
	group 'root'
	mode '755'
end

template '/etc/systemd/system/clamav-daemon.socket.d/extend.conf' do
	source 'clamav-daemon.socket-extend.conf.erb'
	owner 'root'
	group 'root'
	mode '644'
	variables(
		:port_number => node['cc-webapp']['virus_scanner']['port_number'],
		:ip_address => node['cc-webapp']['virus_scanner']['ip_address']
	)
end


execute 'Enable ClamAV socket wait path' do
	command 'systemctl enable clamav-socket-wait.path'
	action :run
end

execute 'Enable ClamAV socket wait service' do
	command 'systemctl enable clamav-socket-wait.service'
	action :run
end

execute 'Enable ClamAV daemon wait path' do
	command 'systemctl enable clamav-daemon-wait.path'
	action :run
end

execute 'Enable ClamAV daemon wait service' do
	command 'systemctl enable clamav-daemon-wait.service'
	action :run
end

execute 'Enable ClamAV daemon' do
	command 'systemctl enable clamav-daemon.service'
	action :run
end

execute 'Enable ClamAV socket' do
	command 'systemctl enable clamav-daemon.socket'
	action :run
end


execute 'ClamAV daemon reload' do
	command 'systemctl daemon-reload'
	action :run
end

execute 'Restart clamav daemon' do
	command 'service clamav-daemon restart'
	action :run
end





