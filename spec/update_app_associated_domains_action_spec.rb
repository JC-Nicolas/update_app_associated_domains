describe Fastlane::Actions::UpdateAppAssociatedDomainsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The update_app_associated_domains plugin is working!")

      Fastlane::Actions::UpdateAppAssociatedDomainsAction.run(nil)
    end
  end
end
