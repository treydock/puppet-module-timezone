require 'spec_helper_acceptance'

describe 'timezone' do
  context 'default' do
    it 'should work without errors and be idempotent' do
      pp = <<-EOS
      include timezone
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/localtime') do
      it { should be_symlink }
      it { should be_linked_to '/usr/share/zoneinfo/UTC' }
    end

    if fact('os.family') == 'RedHat' and fact('os.release.major') == '6'

      content = <<-END.gsub(/^\s+\|/, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |#
        |ZONE="UTC"
        |UTC=true
      END

      describe file('/etc/sysconfig/clock') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode '644' }
        its(:content) { should eq content }
      end
    end

    if fact('os.family') == 'Debian'

      content = <<-END.gsub(/^\s+\|/, '')
        |UTC
      END

      describe file('/etc/timezone') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode '644' }
        its(:content) { should eq content }
      end
    end
  end

  context 'changing timezone' do
    it 'should be able to change the timezone' do
      pp = <<-EOS
      class { 'timezone':
        timezone => 'Europe/Berlin',
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    # Ubuntu seems to take a moment to reflect the change. So we pause for 5
    # seconds.
    if fact('os.name') == 'Ubuntu'
      describe command('sleep 5') do
      end
    else
      describe command('date +"%Z"') do
        its(:stdout) { should match /CET/ }
      end
    end
  end
end
