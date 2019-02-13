require 'spec_helper'

describe 'timezone' do
  let(:facts) do
    {
      :os => {
        :family => 'RedHat',
        :release => {
          :major  => '7',
        },
      },
    }
  end

  context 'On Debian system with default values for all parameters' do
    let(:facts) do
      {
        :os => {
          :family => 'Debian',
        },
      }
    end

    it {
      should contain_file('/etc/localtime').with_ensure('link').
        with_target('/usr/share/zoneinfo/UTC')
    }

    it {
      should contain_file('/etc/timezone').with({
        'owner' => 'root',
        'group' => 'root',
        'mode'  => '0644',
        'content' => "UTC\n",
      })
    }
  end

  describe 'on EL' do
    ['6','7'].each do |release|
      describe "release #{release}" do
        context 'with default values for all parameters' do
          let(:facts) do
            {
              :os => {
                :family => 'RedHat',
                :release => {
                  :major => release,
                },
              },
            }
          end

          it {
            should contain_file('/etc/localtime').with_ensure('link').
              with_target('/usr/share/zoneinfo/UTC')
          }

          if release == '7'
            it { should_not contain_file('/etc/sysconfig/clock') }
          else
            it {
              should contain_file('/etc/sysconfig/clock').with({
                'owner' => 'root',
                'group' => 'root',
                'mode'  => '0644',
              })
            }

            content = <<-END.gsub(/^\s+\|/, '')
              |# This file is being maintained by Puppet.
              |# DO NOT EDIT
              |#
              |ZONE="UTC"
              |UTC=true
            END

            it { should contain_file('/etc/sysconfig/clock').with_content(content) }
          end
        end
      end
    end
  end

  context "on EL6 system with hwclock_utc specified" do
    [true,false].each do |value|
      context "as #{value}" do
        let(:params) do
          { :hwclock_utc => value }
        end
        let(:facts) do
          {
            :os => {
              :family => 'RedHat',
              :release => {
                :major => '6',
              },
            },
          }
        end

        it { should contain_file('/etc/sysconfig/clock').with_content(/UTC=#{value}/) }
      end
    end
  end

  context "on EL7 system with timezone specified (Europe/Berlin)" do
    let(:params) do
      { :timezone => 'Europe/Berlin' }
    end
    let(:facts) do
      {
        :os => {
          :family => 'RedHat',
          :release => {
            :major => '7',
          },
        },
      }
    end

    it {
      should contain_file('/etc/localtime').with_ensure('link').
        with_target('/usr/share/zoneinfo/Europe/Berlin')
    }
  end

  context "on Debian system with timezone specified (Europe/Berlin)" do
    let(:params) do
      { :timezone => 'Europe/Berlin' }
    end
    let(:facts) do
      {
        :os => {
          :family => 'Debian',
        },
      }
    end

    it {
      should contain_file('/etc/localtime').with_ensure('link').
        with_target('/usr/share/zoneinfo/Europe/Berlin')
    }

    it {
      should contain_file('/etc/timezone').with({
        'owner' => 'root',
        'group' => 'root',
        'mode'  => '0644',
        'content' => "Europe/Berlin\n",
      })
    }
  end

  describe 'variable data type and content validations' do
    validations = {
      'boolean (optional)' => {
        :name    => %w(hwclock_utc),
        :valid   => [true, false],
        :invalid => ['string', %w(array), { 'ha' => 'sh' }, 3, 2.42, 'false'],
        :message => 'expects a value of type Undef or Boolean',
      },
      'string' => {
        :name    => %w(timezone),
        :valid   => %w(string),
        :invalid => [%w(array), { 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a String value',
      },
    }

    validations.sort.each do |type, var|
      mandatory_params = {} if mandatory_params.nil?
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:facts) { [mandatory_facts, var[:facts]].reduce(:merge) } if ! var[:facts].nil?
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
