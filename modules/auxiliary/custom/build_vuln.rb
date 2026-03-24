class MetasploitModule < Msf::Auxiliary
  def initialize(info = {})
    super(update_info(info,
      'Name'        => 'Build Vulnerable Labs',
      'Description' => 'Run multiple vulnerable apps using Docker (DVWA, Juice, WebGoat, etc.)',
      'Author'      => ['Ahmed'],
      'License'     => MSF_LICENSE
    ))

    register_options(
      [
        OptEnum.new('ACTION', [true, 'Action to perform: start, stop, list', 'start', ['start','stop','list']]),
        OptString.new('TARGET', [false, 'Target(s) to run (comma-separated if multiple)', 'dvwa']),
        OptInt.new('PORT', [false, 'Custom port (optional)'])
      ]
    )
  end

  # ====================
  # Main run
  # ====================
  def run
    action = datastore['ACTION']
    target = datastore['TARGET']

    case action
    when 'list'
      list_containers
    when 'stop'
      stop_all_containers
    when 'start'
      start_target(target)
    else
      print_error("Unknown action! Use: start | stop | list")
    end
  end

  # ====================
  # Helper methods
  # ====================
  def start_target(target)
    targets = {
      'dvwa' => {image: 'vulnerables/web-dvwa', internal_port: 80, default_port: 8080},
      'juice' => {image: 'bkimminich/juice-shop', internal_port: 3000, default_port: 3000},
      'webgoat' => {image: 'webgoat/webgoat', internal_port: 8080, default_port: 8081},
      'bwapp' => {image: 'raesene/bwapp', internal_port: 80, default_port: 8082},
      'mutillidae' => {image: 'citizenstig/nowasp', internal_port: 80, default_port: 8083}
    }

    targets_list = target.split(',').map(&:strip)
    targets_list.each do |t|
      if targets.key?(t)
        info = targets[t]
      else
        # Dynamic target
        info = {image: t, internal_port: 80, default_port: find_free_port(8080)}
        print_status("Dynamic target detected: #{t}, using Docker image name same as target")
      end

      port = datastore['PORT'] || info[:default_port]
      cmd = "docker run -d -p #{port}:#{info[:internal_port]} #{info[:image]}"
      result = system(cmd)

      if result
        print_good("#{t} started at http://localhost:#{port}")
      else
        print_error("Failed to start #{t} (maybe image doesn't exist or port is in use)")
      end
    end
  end

  def list_containers
    system("docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'")
  end

  def stop_all_containers
    system("docker stop $(docker ps -q)")
    print_good("All containers stopped!")
  end

  def find_free_port(start_port)
    port = start_port
    loop do
      return port if port_free?(port)
      port += 1
    end
  end

  def port_free?(port)
    !system("lsof -i:#{port} > /dev/null 2>&1")
  end
end
