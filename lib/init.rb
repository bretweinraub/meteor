
#
# Inject meteor methods into the rails base classes
#

ActionController::Base.send(:include, Meteor::Helpers::ActionControllerHelpers)
ActionView::Base.send(:include, Meteor::Helpers::ActionViewHelpers)
