# encoding: UTF-8
#
# Взаимодействие с API Яндекс.Директа в формате JSON.
# http://api.yandex.ru/direct/doc/concepts/JSON.xml
#
# (c) Copyright 2012 Евгений Шурмин. All Rights Reserved. 
#

module Yandex::API
  module Direct
    #
    # = PhraseUserParams
    #
    class PhraseUserParams < Base
      direct_attributes :Param1, :Param2
    end
    #
    # = CoverageInfo
    #
    class CoverageInfo < Base
      direct_attributes :Probability, :Price
    end
    #
    # = Phrases
    #
    class BannerPhraseInfo < Base
      direct_attributes :BannerID, :CampaignID, :AdGroupID, :PhraseID, :Phrase, :IsRubric, :Price, :ContextPrice, :AutoBroker, :StatusPhraseModerate, :AutoBudgetPriority,
                        :Clicks, :Shows, :ContextClicks, :ContextShows, :Min, :Max, :PremiumMin, :PremiumMax, :LowCTRWarning, :LowCTR, :ContextLowCTR,
                        :Prices, :CurrentOnSearch, :MinPrice, :StatusPaused, :Currency
      direct_objects [:UserParams, PhraseUserParams], [:Coverage, CoverageInfo], [:ContextCoverage, CoverageInfo]
    end
    
    #
    # = Sitelink
    #
    class Sitelink < Base
      direct_attributes :Title, :Href
    end
    
    #
    # = MapPoint
    #
    class MapPoint < Base
      direct_attributes :x, :y, :x1, :y1, :x2, :y2
    end

    #
    # = ContactInfo
    #
    class ContactInfo < Base
      direct_attributes :ContactPerson, :Country, :CountryCode, :City, :Street, :House, :Build, :Apart, :CityCode, :Phone,
                        :PhoneExt, :CompanyName, :IMClient, :IMLogin, :ExtraMessage, :ContactEmail, :WorkTime, :OGRN
      direct_objects [:PointOnMap, MapPoint]
    end

    #
    # = RejectReason
    #
    class RejectReason < Base
      direct_attributes :Type, :Text
    end
    
    #
    # = Banner
    #
    class BannerInfo < Base
      direct_attributes :BannerID, :CampaignID, :AdGroupID, :AdGroupName, :Title, :Text, :Href, :Domain, :Geo,
                        :StatusActivating, :StatusArchive, :StatusBannerModerate, :StatusPhrasesModerate, :StatusPhoneModerate, :StatusAdImageModerate,
                        :StatusShow, :IsActive, :StatusSitelinksModerate, :AdWarnings, :FixedOnModeration, :MinusKeywords, :AgeLabel, :AdImageHash
      direct_arrays [:Phrases, BannerPhraseInfo], [:Sitelinks, Sitelink], [:ModerateRejectionReasons, RejectReason]
      direct_objects [:ContactInfo, ContactInfo]
      def self.find id
        result = Direct::request("GetBanners", {:BannerIDS => [id]})
        raise Yandex::NotFound.new("not found banner where id = #{id}") unless result.any?
        banner = new(result.first)
      end
      def save
        self.BannerID = Direct::request("CreateOrUpdateBanners", [self.to_hash]).first
      end

      def archive
        Direct::request("ArchiveBanners", {:BannerIDS => [self.BannerID]})
      end
      def unarchive
        Direct::request("UnArchiveCampaign", {:BannerIDS => [self.BannerID]})
      end
      def moderate
        Direct::request("ModerateBanners", {:BannerIDS => [self.BannerID]})
      end
      def resume
        Direct::request("ResumeBanners", {:BannerIDS => [self.BannerID]})
      end
      def stop
        Direct::request("StopBanners", {:BannerIDS => [self.BannerID]})
      end
      def delete
        Direct::request("DeleteBanners", {:BannerIDS => [self.BannerID]})
      end
    end
  end
end