Puppet::Type.type(:ulimit).provide(:default) do
  desc "Default provider for ulimit resource type."

  LIMITS_DIR = '/etc/security/limits.d/'
  # If for some reason limits.conf order changes, update this constant.
  LIMIT_ORDER = %w[domain type item value].map(&:to_sym)

  confine :exists => LIMITS_DIR

  attr_accessor :comment, :name, *LIMIT_ORDER

  def create
    File.open(get_filename(@resource[:name]), File::WRONLY|File::CREAT|File::TRUNC, 0644) do |f| 
      f.puts "# #{@resource[:comment]}" if @resource[:comment]
      limits = LIMIT_ORDER.map { |l| @resource[l] }
      f.puts "#{limits.join("\t")}"
    end 
  end

  def destroy
    File.unlink(get_filename(@resource[:name]))
  end

  def exists?
    File.exists?(get_filename(@resource[:name]))
  end

  def get_filename(n)
    LIMITS_DIR + n + '.conf'
  end

  def flush
    create  # Just recreate it!
  end

  def self.prefetch(ulimits)
    ulimits.each do |name,ulimit|
      return if !File.exists?(LIMITS_DIR + name + '.conf')

      ulimit_line = File.open(LIMITS_DIR+ name + '.conf', File::RDONLY).readlines[-1].chomp.split(/\s+/,4)
      LIMIT_ORDER.each do |l| 
        # ulimit_line order should be identical to LIMIT_ORDER so combine the two to pull the correct index.
        # then set provider attribute based on that.  I got a little too cute here, maybe.
        ulimit.provider.send("#{l}=", ulimit_line[LIMIT_ORDER.index(l)] )
      end

    end
  end
end
