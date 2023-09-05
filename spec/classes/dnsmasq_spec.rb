# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      case os_facts['osfamily']
      when 'freebsd' then
        it { is_expected.to contain_file('/usr/local/etc/dnsmasq.d/10-dns-server.conf') }
      else
        it { is_expected.to contain_file('/etc/dnsmasq.d/10-dns-server.conf') }
      end
    end
  end
end
