require 'minitest/autorun'
require 'zephyr_api'

module ZephyrApi
  class CloudClientTest < Minitest::Test
    def test_get
      access_key = 'secret'
      secret_key = 'secret'
      user_name = 'secret'
      base_url = 'https://prod-api.zephyr4jiracloud.com/connect'

      client = CloudClient.new(access_key: access_key,
                               secret_key: secret_key,
                               user_name: user_name,
                               base_url: base_url)

      response = client.get('https://prod-api.zephyr4jiracloud.com/connect/public/rest/api/1.0/serverinfo')

      assert_equal '200', response.code
    end
  end
end
