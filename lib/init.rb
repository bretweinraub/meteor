
#
# Inject meteor methods into the ActionController class
#

ActionController::Base.send(:include, Meteor)
