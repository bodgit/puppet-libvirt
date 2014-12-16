Puppet::Type.newtype(:libvirt_network) do

  @doc = 'Manage libvirt networks'

  ensurable do
    defaultvalues
    defaultto(:present)
  end

  newparam(:name) do
    isnamevar
  end

  newproperty(:active) do
    desc 'Whether the network should be active.'
    defaultto(:true)
    newvalues(:true)
    newvalues(:false)
  end

  newproperty(:autostart) do
    desc 'Whether the network should be automatically started.'
    defaultto(:false)
    newvalues(:true)
    newvalues(:false)
  end

  newproperty(:persistent) do
    desc 'Whether the network should be persistent.'
    defaultto(:true)
    newvalues(:true)
    newvalues(:false)
  end

  newproperty(:forward_mode) do
    desc ''
    defaultto(:nat)
    newvalues(:nat)
    newvalues(:bridge)
  end

  newproperty(:bridge) do
    desc 'The bridge interface.'
    newvalues(/^\S+$/)
  end

  newproperty(:stp) do
    desc 'Whether to enable spanning tree.'
    newvalues(:true)
    newvalues(:false)
  end

  newproperty(:delay) do
    desc 'Forward delay for spanning tree.'

    munge do |value|
      if value.is_a?(String)
        unless value =~ /^\d+$/
          raise ArgumentError, 'Delay must be an integer'
        end
        value = Integer(value)
      end
      raise ArgumentError, 'Delay must be an integer > 0' if value < 0
      value
    end
  end

  validate do
    if self[:persistent] == :false
      if self[:active] == :false or self[:autostart] == :true
        self.fail 'Transient networks cannot be inactive or automatically started'
      end
    end
  end
end
