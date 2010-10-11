#
# Base class for widgets that exist in plugins
#

module Meteor
  class PluginSpecBase < SpecBase
    def initial_partial_search_order
      File.join(plugin_name,'templates',widget_name)
    end
  end
end

