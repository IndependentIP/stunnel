actions :create, :delete
default_action :create

attribute :service_name, :kind_of => String
attribute :connect, :required => true
attribute :accept, :required => true
attribute :cafile, :kind_of => String
attribute :cert, :kind_of => String
attribute :cert_file, :kind_of => String
attribute :key, :kind_of => String
attribute :key_file, :kind_of => String
attribute :verify, :kind_of => Integer
attribute :timeout_close, :kind_of => [TrueClass,FalseClass]
attribute :client, :kind_of => [TrueClass,FalseClass]
