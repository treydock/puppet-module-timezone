require 'spec_helper_acceptance'

describe 'timezone' do
  context 'default' do
    it 'works without errors and be idempotent' do
      pp = <<-EOS
      include timezone
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe file('/etc/localtime') do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to '/usr/share/zoneinfo/UTC' }
    end

    if (fact('os.family') == 'RedHat') && (fact('os.release.major') == '6')

      content = <<-END.gsub(%r{^\s+\|}, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |#
        |ZONE="UTC"
        |UTC=true
      END

      describe file('/etc/sysconfig/clock') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
        it { is_expected.to be_mode '644' }
        its(:content) { is_expected.to eq content }
      end
    end

    if fact('os.family') == 'Debian'

      content = <<-END.gsub(%r{^\s+\|}, '')
        |UTC
      END

      describe file('/etc/timezone') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
        it { is_expected.to be_mode '644' }
        its(:content) { is_expected.to eq content }
      end
    end
  end

  context 'changing timezone' do
    it 'is able to change the timezone' do
      pp = <<-EOS
      class { 'timezone':
        timezone => 'Europe/Berlin',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # Ubuntu seems to take a moment to reflect the change. So we pause for 5
    # seconds.
    if fact('os.name') == 'Ubuntu'
      describe command('sleep 5') do
        its(:exit_status) { is_expected.to eq 0 }
      end
    else
      describe command('date +"%Z"') do
        # This covers the change between CET and CEST
        its(:stdout) { is_expected.to match(%r{CES?T}) }
      end
    end
  end
end
