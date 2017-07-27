require 'test_helper'
require 'zephyr_api'

module ZephyrApi
  class CloudClientTest < Minitest::Test
    def test_get
      access_key = 'secret'
      secret_key = 'secret'
      user_name = 'secret'
      base_url = 'https://prod-api.zephyr4jiracloud.com/connect'

      # Mock API call
      authorization_header = ''
      stub_request(:get, 'https://prod-api.zephyr4jiracloud.com/connect/public/rest/api/1.0/serverinfo')
        .with(headers: { 'Content-Type' => 'application/json', 'Zapiaccesskey' => access_key }) { |req| authorization_header = req.headers['Authorization'] }
        .to_return(status: 200, body: '{}', headers: {})

      client = CloudClient.new(access_key: access_key,
                               secret_key: secret_key,
                               user_name: user_name,
                               base_url: base_url)
      response = client.get('https://prod-api.zephyr4jiracloud.com/connect/public/rest/api/1.0/serverinfo')

      assert_equal '200', response.code

      token = authorization_header.split(' ').last
      decoded_token = JWT.decode token, secret_key, true, algorithm: 'HS256'

      assert decoded_token.first['iat']
      assert_equal (decoded_token.first['iat'] + ZephyrApi::CloudClient::TOKEN_EXPIRATION_IN_SECONDS), decoded_token.first['exp']
      assert_equal access_key, decoded_token.first['iss']
      assert_equal user_name, decoded_token.first['sub']
      assert_equal '6a7318e89ae7764f433c980cbb57fd240b1884e06679e973d8518b24ac029089', decoded_token.first['qsh']
    end
  end
end
