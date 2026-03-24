class MetasploitModule < Msf::Auxiliary

  def initialize(info = {})
    super(update_info(info,
      'Name'        => 'Build Vulnerable Lab',
      'Description' => 'Run vulnerable apps using Docker (DVWA, Juice, WebGoat)',
      'Author'      => ['Ahmed'],
      'License'     => MSF_LICENSE
    ))

    register_options(
      [
        OptEnum.new('ACTION', [true, 'Action to perform: start, stop, list', 'start', ['start','stop','list']]),
        OptString.new('TARGET', [false, 'Target to run (dvwa | juice | webgoat)', 'dvwa'])
      ]
    )
  end

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
      'webgoat' => {image: 'webgoat/webgoat', internal_port: 8080, default_port: 8081}
    }

    unless targets.key?(target)
      print_error("Unknown target! Use: dvwa | juice | webgoat")
      return
    end

    info = targets[target]
    port = find_free_port(info[:default_port])
    cmd = "docker run -d -p #{port}:#{info[:internal_port]} #{info[:image]}"
    result = system(cmd)

    if result
      print_good("#{target} started at http://localhost:#{port}")
    else
      print_error("Failed to start #{target} (port may be in use)")
    end
  end

  def list_containers
    system("docker ps")
  end

  def stop_all_containers
    system("docker stop $(docker ps -q)")
    print_good("All containers stopped!")
  end

  def find_free_port(start_port)
    port = start_port
    loop do
      if port_free?(port)
        return port
      else
        port += 1
      end
    end
  end

  def port_free?(port)
    !system("lsof -i:#{port} > /dev/null 2>&1")
  end
end
