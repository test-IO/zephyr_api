require 'net/http'
require 'jwt'

module ZephyrApi
  class CloudClient
    TOKEN_EXPIRATION_IN_SECONDS = 360

    def initialize(access_key:, secret_key:, user_name:, base_url:)
      @access_key = access_key
      @secret_key = secret_key
      @user_name = user_name
      @base_url = base_url
    end

    def get(uri)
      uri = URI(uri) if uri.is_a? String

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      jwt = generate_jwt('GET', uri)
      headers = {
        'Authorization' => "JWT #{jwt}",
        'Content-Type' => 'application/json',
        'zapiAccessKey' => @access_key
      }
      request = Net::HTTP::Get.new(uri.request_uri, headers)

      http.request(request)
    end

    private

    def generate_jwt(method, uri)
      path_without_product_context = uri.path[URI(@base_url).path.length, uri.path.length]

      digest = Digest::SHA256.hexdigest([method, path_without_product_context, canonicalize_query_string(uri.query)].join('&'))
      token_content = {
        iat: Time.now.to_i,
        exp: (Time.now + TOKEN_EXPIRATION_IN_SECONDS).to_i,
        iss: @access_key,
        sub: @user_name,
        qsh: digest
      }

      JWT.encode token_content, @secret_key, 'HS256'
    end

    # from https://bitbucket.org/atlassian/atlassian-jwt-ruby/src/8c54f90bf9e3a77f3dc0beb37659299af9d9c4d8/lib/atlassian/jwt.rb?at=master&fileviewer=file-view-default#jwt.rb-62
    def canonicalize_query_string(query)
      return '' if query.nil? || query.empty?
      query = CGI.parse(query)
      query.delete('jwt')
      query.each do |k, v|
        query[k] = v.map { |a| CGI.escape a }.join(',') if v.is_a? Array
        query[k].gsub!('+', '%20') # Use %20, not CGI.escape default of "+"
        query[k].gsub!('%7E', '~') # Unescape "~" per JS tests
      end
      query = Hash[query.sort]
      query.map { |k, v| "#{CGI.escape k}=#{v}" }.join('&')
    end
  end
end
