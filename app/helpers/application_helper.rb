require 'aws-sdk'
require 'tempfile'
require 'escape'

require 'octocore'

module ApplicationHelper
  include Octo::Helpers::ClientHelper

  def counters_text
    mapping_as_choice Octo::Counter::Helper.counter_text
  end

  # Create a new Client
  # @param [String] username The name of the client
  # @param [String] email The email of the client
  # @param [String] password The password of the client
  # @return [String] The status of request
  def create_client(username, email, password)
    add_consumer(username, email, password)
  end

  # Converts a hash mapping into choices ready for UX
  # @return [Array<Hash{Symbol => String }>] The hash containing key :text
  #   as the text to display, and another key :id as the id to be used
  #   as reference while communicating
  def mapping_as_choice(map)
    map.inject([]) do | choices, pair |
      key, val = pair
      choices << { text: val, id: key }
    end
  end

  # Get the first enterprise object for debugging
  def get_enterprise
    Octo::Enterprise.where(id: session[:consumer_id]).first
  end

  # Get Enterprise Id of logged in user
  def get_enterprise_id
    session[:consumer_id]
  end

  # Get Octo api key for logged user
  def get_api_key
    enterprise = get_enterprise
    Octo::Authorization.find_by_username(enterprise.name).apikey
  end

  def args_with_time(args)
    ts_start = mktime_from_urlparam(@params[:start_time])
    ts_end = mktime_from_urlparam(@params[:end_time])

    if ts_end.nil?
      if ts_start.nil?
        return args.merge({ts: 30.minutes.ago - Time.now.floor})
      else
        return args.merge({ts: ts_start})
      end
    else
      return args.merge({ts: ts_start..ts_end})
    end
  end

  def mktime_from_urlparam(str)
    return nil if str.nil?
    Time.parse(str, 'YYYYMMDDhhmmss')
  end

  # Convert P12 certificate to PEM Format (IOS Certificate)
  # @param [String] p12 Certificate Data
  # @param [String] pass Password if any
  # @return [String] pem formatted certificate data
  def p12_to_pem_text(p12, pass='')
    pass = '' if pass.nil?

    if RUBY_PLATFORM == 'java'
      tf_p12 = Tempfile.new 'tf_p12'
      tf_p12.write p12
      tf_p12.close

      tf_pem = Tempfile.new 'tf_pem'
      tf_pem.close

      cmd = Escape.shell_command(['openssl', 'pkcs12', '-in', tf_p12.path, '-out', tf_pem.path, 
                                  '-nodes', '-clcerts', '-password', 'pass:'+pass]).to_s + ' &> /dev/null'

      begin
        result = system cmd
        raise CommandFailError if result.nil? || result == false
        pem = File.read tf_pem.path
      ensure
        tf_pem.unlink
        tf_p12.unlink
      end

      pem
    else
      pkcs12 = OpenSSL::PKCS12.new p12, pass
      pkcs12.certificate.to_s + pkcs12.key.to_s
    end
  end

  # Upload P12 certificate & PEM certificate to S3 (IOS Certificate)
  # @param [String] p12 Certificate Data
  def upload_certificate(p12)
    config = Octo.get_config(:aws, nil)

    _access_key = config[:access_key] || ENV['AWS_ACCESS_KEY']
    _secret_key = config[:secret_key] || ENV['AWS_SECRET_KEY']

    Aws.config.update({
      region: config[:region],
      credentials: Aws::Credentials.new(_access_key, _secret_key)
    })

    s3 = Aws::S3::Resource.new(region: config[:region])

    p12_file = Tempfile.new 'p12_file'
    p12_file.write p12
    p12_file.close

    pem_file = Tempfile.new 'pem_file'
    pem_file.write p12_to_pem_text(p12)
    pem_file.close

    filepath = get_enterprise_id + '/ioscertificate.p12'
    obj = s3.bucket(config[:bucket_name]).object(filepath)
    resp = obj.upload_file(p12_file.path)

    filepath = get_enterprise_id + '/ioscertificate.pem'
    obj = s3.bucket(config[:bucket_name]).object(filepath)
    resp = obj.upload_file(pem_file.path)

    Cequel::Record.redis.del(get_enterprise_id)

    p12_file.unlink
    pem_file.unlink
  end

  def fa_caret(val, opts={})
    val = val.to_f.round(2)
    rows = []
    if val > 0
      rows << '<p class="font-montserrat text-success no-margin fs-16">'
      rows << "<i class='fa fa-caret-up'></i> +#{ val } <span class='font-arial text-white fs-12 hint-text m-l-5'>#{ opts.fetch(:text, '') }</span>"
    elsif val < 0
      rows << '<p class="font-montserrat text-danger no-margin fs-16">'
      rows << "<i class='fa fa-caret-down'></i> #{ val } <span class='font-arial text-white fs-12 hint-text m-l-5'>#{ opts.fetch(:text, '') }</span>"
    else
      rows << '<p class="font-montserrat text-danger no-margin fs-16">'
      rows << "<i class='fa fa-caret-down'></i> #{ val } <span class='font-arial text-white fs-12 hint-text m-l-5'>#{ opts.fetch(:text, '') }</span>"
    end
    rows << '</p>'
    rows.join
  end

  def trend_text_for(trend)
    case trend.to_s
    when 'Octo::ProductTrend'
      'product'
    when 'Octo::CategoryTrend'
      'category'
    when 'Octo::TagTrend'
      'tag'
    end
  end

end
