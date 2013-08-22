app_dir = "/home/vagrant/sinatra_hello"

execute "git clone https://github.com/arupchak/sinatra_hello #{app_dir}"
execute "echo 'set :bind, \"0.0.0.0\"' >> #{app_dir}/hello.rb"
execute "chown -R vagrant:vagrant #{app_dir}"

execute "cronadd" do 
	command "crontab -u vagrant ~vagrant/crontab"
	action :nothing
end

service "webapp" do
	provider Chef::Provider::Service::Upstart
	supports :restart => true, :start => true, :stop => true
end

template "webapp.upstart.conf" do
	path "/etc/init/webapp.conf"
	source "webapp.upstart.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables({
		:app_dir => app_dir
	})
	notifies :enable, resources(:service => "webapp")
	notifies :start, resources(:service => "webapp")
end

template "webapp_launcher" do
	path "#{app_dir}/webapp_launcher"
	source "webapp_launcher.erb"
	owner "vagrant"
	group "vagrant"
	mode "0755"
	variables({
		:app_dir => app_dir
	})
end

template "parser" do
	path "/home/vagrant/parser.rb"
	source "parser.rb.erb"
	owner "vagrant"
	group "vagrant"
	mode "0775"
end	

template "crontab" do
	path "/home/vagrant/crontab"
	source "crontab.erb"
	owner "vagrant"
	group "vagrant"
	mode "0655"
	variables({
		:app_dir => app_dir
	})
	notifies :run, "execute[cronadd]"
end

service "webapp" do
	action [:enable, :start]
end

