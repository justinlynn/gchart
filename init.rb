require 'gchart'

ActionController::Base.send(:include, GChart)
ActiveRecord::Base.send(:include, GChart)