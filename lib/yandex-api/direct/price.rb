module Yandex::API
  module Direct
    class Price
      def self.UpdatePrices prices
        Direct::request("UpdatePrices", prices)
      end
    end
  end
end