require "yandex-api/version"
require "yandex-api/direct"
require "yandex-api/direct/base"
require "yandex-api/direct/banner_info"
require "yandex-api/direct/campaign_info"
require "yandex-api/direct/finance"
require "yandex-api/direct/price"

module Yandex
  module API
    class RuntimeError < RuntimeError ; end
    class NotFound < RuntimeError ; end
  end
end
