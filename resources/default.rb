#

actions :extract
default_action :extract

attribute :filename, :kind_of => String, :name_attribute => true
attribute :target,   :kind_of => String

attribute :clobber,  :kind_of => [ TrueClass, FalseClass], :default => false
attribute :verbose,  :kind_of => [ TrueClass, FalseClass], :default => false
