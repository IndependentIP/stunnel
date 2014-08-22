directory '/etc/stunnel/'

# Copy over the certificate_file from the files folder
if node[:stunnel][:certificate_file]
  unless node[:stunnel][:certificate_path]
    node.default[:stunnel][:certificate_path] = "/ets/stunnel/stunnel.pem"
  end

  cookbook_file node[:stunnel][:certificate_file] do
    path node[:stunnel][:certificate_path]
    mode "0600"
    owner "root"
    group "root"
    action :create_if_missing
  end
end

unless node[:stunnel][:certificate_path]
  execute "Create stunnel SSL Certificates" do
    command "openssl req -subj \"#{node[:stunnel][:server_ssl_req]}\" -new -nodes -x509 -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem"
    creates '/etc/stunnel/stunnel.pem'
  end

  file '/etc/stunnel/stunnel.pem' do
    mode 0600
  end

  node.default[:stunnel][:certificate_path] = '/etc/stunnel/stunnel.pem'
end

node.default[:stunnel][:client_mode] = false

include_recipe 'stunnel'
