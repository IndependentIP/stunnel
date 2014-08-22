node[:stunnel][:packages].each do |s_pkg|
  package s_pkg
end

if node[:stunnel][:services].any?
  node[:stunnel][:services].each do |name, service|
    # Copy over the keys and certs if specified in the node
    [:key, :cert, :cafile].each do |type|
      if service["#{type}_location"]
        cookbook_file service["#{type}_location"] do
          cookbook node[:stunnel][:files_cookbook]
          path service[type]
          mode "0600"
          owner "root"
          group "root"
          action :create_if_missing
        end
      end
    end
  end
end

# Create directory to hold the pid inside the chroot jail
if(node[:stunnel][:use_chroot])
  directory "#{node[:stunnel][:chroot_path]}" do
    owner node[:stunnel][:user]
    group node[:stunnel][:group]
    recursive true
    action :create
  end
end

unless(node.platform_family == 'debian')
  user 'stunnel4' do
    home '/var/run/stunnel4'
    system true
    shell '/bin/false'
    supports :manage_home => true
  end
  cookbook_file '/etc/init.d/stunnel4' do
    source 'stunnel4'
    mode 0755
  end
end

ruby_block 'stunnel.conf notifier' do
  block do
    true
  end
  notifies :create, 'template[/etc/stunnel/stunnel.conf]', :delayed
end

template "/etc/stunnel/stunnel.conf" do
  source "stunnel.conf.erb"
  mode 0644
  action :nothing
  notifies :restart, 'service[stunnel]', :delayed
end

template "/etc/default/stunnel4" do
  source "stunnel.default.erb"
  mode 0644
end

service "stunnel" do
  service_name node[:stunnel][:service_name]
  supports :restart => true, :reload => true
  action [ :enable, :start ]
  not_if do
    node[:stunnel][:services].empty?
  end
end
