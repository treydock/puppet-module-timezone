require 'spec_helper'

describe 'timezone', :type => 'class' do
  context "On a RedHat system with default time-zone" do
    let(:facts) do
      {
        :osfamily => 'RedHat'
      }
    end

    it {
      should contain_file('/etc/localtime').with_ensure('link').
        with_target('/usr/share/zoneinfo/UTC')
    }

    it {
      should contain_file('/etc/sysconfig/clock').
        with_owner('root').
        with_group('root').
        with_mode('0644').
        with_content("ZONE=\"UTC\"\nUTC=true\n")
    }
  end

  context "On RedHat system with time-zone Europe/Berlin" do
    let(:facts) do { :osfamily => 'RedHat' } end

    it {
      should contain_file('/etc/localtime').with_ensure('link').
        with_target('/usr/share/zoneinfo/UTC')
    }
  end

  context "On Debian system with default time-zone" do
    let(:facts) do { :osfamily => 'Debian' } end

    it {
      should contain_file('/etc/localtime').
        with_owner('root').
        with_group('root').
        with_mode('0644')
    }
    it {
      should contain_file('/etc/timezone').
        with_owner('root').
        with_group('root').
        with_mode('0644').
        with_content("UTC\n")
    }
  end
end
