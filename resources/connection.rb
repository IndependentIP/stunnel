actions :create, :delete
default_action :create

attribute :service_name, :kind_of => String
attribute :connect, :required => true
attribute :accept, :required => true
attribute :cafile, :kind_of => String
attribute :cafile_location, :kind_of => String
attribute :cert, :kind_of => String
attribute :cert_location, :kind_of => String
attribute :key, :kind_of => String
attribute :key_location, :kind_of => String
attribute :verify, :kind_of => Integer
attribute :delay, :kind_of => String
attribute :timeout_close, :kind_of => [TrueClass,FalseClass]
attribute :client, :kind_of => [TrueClass,FalseClass]
