def load_current_resource
  node[:stunnel][:services] ||= {}
  unless(new_resource.service_name)
    new_resource.service_name new_resource.name
  end
end

action :create do
  hsh = Mash.new(
    :connect => new_resource.connect,
    :accept => new_resource.accept,
    :cafile => new_resource.cafile,
    :cafile_location => new_resource.cafile_location,
    :cert => new_resource.cert,
    :cert_location => new_resource.cert_location,
    :key => new_resource.key,
    :key_location => new_resource.key_location,
    :verify => new_resource.verify,
    :delay => new_resource.delay,
    :timeout_close => new_resource.timeout_close,
    :client => new_resource.client
  )
  exist = Mash.new(node[:stunnel][:services][new_resource.service_name])
  if(exist != hsh)
    node.set[:stunnel][:services][new_resource.service_name] = hsh
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  serv_data = Mash.new(node[:stunnel][:services])
  if(serv_data.delete(new_resource.service_name))
    node.set[:stunnel][:services] = serv_data
    new_resource.updated_by_last_action(true)
  end
end
