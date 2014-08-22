directory '/etc/stunnel/'

# Copy over the certificate_file from the files folder
[:certificate, :key].each do |type|
  location = "#{type}_location"
  path = "#{type}_path"

  if location
    unless path
      ext = type == :certificate ? 'crt' : 'key'
      node.default[:stunnel]["#{type}_path"] = "/etc/stunnel/stunnel-#{type}.#{ext}"
    end

    cookbook_file location do
      cookbook node[:stunnel][:files_cookbook]
      path path
      mode "0600"
      owner node[:stunnel][:user]
      group node[:stunnel][:group]
      action :create
    end
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
