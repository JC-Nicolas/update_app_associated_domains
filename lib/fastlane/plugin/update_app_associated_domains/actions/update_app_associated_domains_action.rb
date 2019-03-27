require 'fastlane/action'
require_relative '../helper/update_app_associated_domains_helper'

module Fastlane
  module Actions
    class UpdateAppAssociatedDomainsAction < Action
      require 'plist'

      def self.run(params)
        UI.message("Entitlements File: #{params[:entitlements_file]}")
        UI.message("New Associated Domains: #{params[:app_associated_domains]}")

        entitlements_file = params[:entitlements_file]
        UI.user_error!("Could not find entitlements file at path '#{entitlements_file}'") unless File.exist?(entitlements_file)

        # parse entitlements
        result = Plist.parse_xml(entitlements_file)
        UI.user_error!("Entitlements file at '#{entitlements_file}' cannot be parsed.") unless result

        # get app group field
        app_group_field = result['com.apple.developer.associated-domains']
        UI.user_error!("No existing associated domains specified. Please specify an associated domain in the entitlements file.") unless app_group_field

        # set new app group identifiers
        UI.message("Old Associated Domains: #{app_group_field}")
        result['com.apple.developer.associated-domains'] = params[:app_associated_domains]

        # save entitlements file
        result.save_plist(entitlements_file)
      end

      def self.description
        "[iOS] Replace associated domains array for the key <com.apple.developer.associated-domains> in the entitlement file."
      end

      def self.authors
        ["Nicolas TRUTET"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "[iOS] Replace associated domains array for the key <com.apple.developer.associated-domains> in the entitlement file."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :entitlements_file,
                                       env_name: "FL_UPDATE_ASSOCIATED_DOMAINS_ENTITLEMENTS_FILE_PATH", # The name of the environment variable
                                       description: "The path to the entitlement file which contains the app group identifiers", # a short description of this parameter
                                       verify_block: proc do |value|
                                         UI.user_error!("Please pass a path to an entitlements file. ") unless value.include?(".entitlements")
                                         UI.user_error!("Could not find entitlements file") if !File.exist?(value) && !Helper.test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_associated_domains,
                                       env_name: "FL_UPDATE_ASSOCIATED_DOMAINS_ASSOCIATED_DOMAINS",
                                       description: "An Array of unique identifiers for the associated domains. Eg. ['com.apple.developer.associated-domains']",
                                       is_string: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("The parameter app_associated_domains need to be an Array.") unless value.kind_of?(Array)
                                       end)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
