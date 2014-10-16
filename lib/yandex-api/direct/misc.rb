module Yandex::API
  module Direct
    class Misc
      def self.regions
        Direct::request("GetRegions")
      end
    end
  end
end