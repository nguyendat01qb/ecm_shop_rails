class Slack::PushErrorService
  attr_reader :message, :url, :api_error, :data, :mention, :host_name, :env

  def initialize(data, message, api_error = false, mention = false, url = Settings.slack.error_500)
    @message = message
    @url = url
    @api_error = api_error
    @data = data
    @mention = mention
    @host_name = `hostname`.strip
    @env = Rails.env.production? ? "`production`" : Rails.env
  end

  def push
    return if Rails.env.test?
    jwt_data = JwtData.encode(data)
    text = api_error ? 'url_enpoint' : 'message'
    to_all = mention ? '<!here>' : ''
    messages = "#{to_all} *ENV*: #{env}\n*Server:* #{host_name}\n*#{text}*: #{message} \n*exception*: ```#{jwt_data}```"
    notifier = Slack::Notifier.new url
    notifier.ping messages
  rescue => e
    p e.message
  end

  def warn
    return if Rails.env.test?
    notifier = Slack::Notifier.new url
    notifier.ping message
  rescue => e
    p e.message
  end

  def output
    return if Rails.env.test?
    jwt_data = JwtData.encode(data)
    messages = "*ENV*: #{env}\n *Server:* #{host_name}\n*message*: #{message} \n *data*: ```#{jwt_data}```"
    notifier = Slack::Notifier.new url
    notifier.ping messages
  rescue => e
    p e.message
  end
end
