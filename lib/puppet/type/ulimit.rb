Puppet::Type.newtype(:ulimit) do
  @doc = "Puppet type that creates a new ulimit.d/<namevar>.conf file"

  ensurable 

  newparam(:name, :namevar => true) do
    desc "Unique filename for ulimit.d file."
    newvalues(/^[0-9a-zA-Z\-\.\_]+$/)
  end

  newproperty(:type) do
    desc "Rule type"
    defaultto '-'
    newvalues(:soft,:hard,:-)
  end

  newproperty(:item) do
    desc "Item to set limit on"
    newvalues(:core, :data, :fsize, :memlock, :nofile,
              :rss, :stack, :cpu, :nproc, :as, :maxlogins,
              :maxsyslogins, :priority, :locks, :sigpending,
              :msgqueue, :nice, :rtprio, :chroot)
  end

  newproperty(:value) do
    desc "Limit item value"
  end

  newproperty(:domain) do
    desc "Domain rule will apply to (root,@wheel,etc)"
    defaultto '*'
  end

  newproperty(:comment) do
    desc "Optional comment that will be placed in the first line of the file."
  end

end

