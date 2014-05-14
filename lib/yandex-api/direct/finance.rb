module Yandex::API
  module Direct
    class Finance
      def self.transfer_money from_compaign_id, to_compaign_id, sum, operation_num, currency = "RUB"
        Direct::finance_request("TransferMoney", operation_num, {
            :FromCampaigns => [
                {
                    :CampaignID => from_compaign_id,
                    :Sum => sum,
                    :Currency => currency
                }
            ],
            :ToCampaigns => [
                {
                    :CampaignID => to_compaign_id,
                    :Sum => sum,
                    :Currency => currency
                }
            ]
        })
      end
    end
  end
end