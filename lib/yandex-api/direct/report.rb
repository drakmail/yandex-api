module Yandex::API
  module Direct
    class Report
      def self.banners compaign_id, start_date, end_date=start_date, currency = "RUB"
        Direct::request("GetBannersStat", {
            :CampaignID => compaign_id,
            :Currency => currency,
            :StartDate => start_date,
            :EndDate => end_date,
            :GroupByColumns => ['clDate', 'clPhrase']})
      end
    end
  end
end