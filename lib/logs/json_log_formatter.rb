class JsonLogFormatter < ::Logger::Formatter
  def call(severity, time, progname, msg)
    json = { time: time, progname: progname, severity: severity, message: msg2str(msg) }
      .compact_blank
      .to_json
    "#{json}\n"
  end
end