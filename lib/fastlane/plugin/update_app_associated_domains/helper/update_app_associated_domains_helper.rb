require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class UpdateAppAssociatedDomainsHelper
      # class methods that you define here become available in your action
      # as `Helper::UpdateAppAssociatedDomainsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the update_app_associated_domains plugin helper!")
      end
    end
  end
end
