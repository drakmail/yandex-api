#
# Взаимодействие с API Яндекс.Директа в формате JSON.
# http://api.yandex.ru/direct/doc/concepts/JSON.xml
#
# (c) Copyright 2012 Евгений Шурмин. All Rights Reserved. 
#

module Yandex::API
  module Direct
    #
    # = CampaignStrategy
    #
    class CampaignStrategy < Base
      direct_attributes :StrategyName, :MaxPrice, :AveragePrice, :AverageCPA, :WeeklySumLimit, :ClicksPerWeek, :GoalID
    end

    #
    # = CampaignContextStrategy
    #
    class CampaignContextStrategy < Base
      direct_attributes :StrategyName, :ContextLimit, :ContextLimitSum, :ContextPricePercent, :MaxPrice, :AveragePrice, :AverageCPA, :WeeklySumLimit, :ClicksPerWeek, :GoalID
    end
    
    #
    # = SmsNotification
    #
    class SmsNotification < Base
      direct_attributes :MetricaSms, :ModerateResultSms, :MoneyInSms, :MoneyOutSms, :SmsTimeFrom, :SmsTimeTo
    end
    
    #
    # = EmailNotification
    #
    class EmailNotification < Base
      direct_attributes :Email, :WarnPlaceInterval, :MoneyWarningValue, :SendAccNews, :SendWarn
    end
    
    #
    # = TimeTargetItem
    #
    class TimeTargetItem < Base
      direct_attributes :Days, :Hours, :BidCoefs
    end

    #
    # = TimeTargetInfo
    #
    class TimeTarget < Base
      direct_attributes :ShowOnHolidays, :HolidayShowFrom, :HolidayShowTo, :TimeZone, :WorkingHolidays
      direct_arrays [:DaysHours, TimeTargetItem]
    end

    #
    # = DayBudgetInfo
    #
    class DayBudgetInfo < Base
      direct_attributes :Amount, :SpendMode
    end

    #
    # = CampaignInfo
    #
    class CampaignInfo < Base
      direct_attributes :Login, :CampaignID, :Name, :FIO, :StartDate, :Sum, :Rest, :BonusDiscount, :Shows, :Clicks, :Currency, :CampaignCurrency, :SourceCampaignID,
              :ClickTrackingEnabled, :AdditionalMetrikaCounters, :Status,
              :StatusBehavior, :StatusContextStop, :ContextLimit, :ContextLimitSum, :ContextPricePercent,
              :AutoOptimization, :StatusMetricaControl, :DisabledDomains, :DisabledIps, :StatusOpenStat, :ConsiderTimeTarget, :ManagerName, :AgencyName, :StatusShow, :StatusArchive, :StatusActivating, :StatusModerate, :IsActive, :MinusKeywords, :AddRelevantPhrases,
              :RelevantPhrasesBudgetLimit, :SumAvailableForTransfer, :DayBudgetEnabled
      direct_objects [:Strategy, CampaignStrategy], [:ContextStrategy, CampaignContextStrategy], [:SmsNotification, SmsNotification], [:EmailNotification, EmailNotification], [:TimeTarget, TimeTarget], [:DayBudget, DayBudgetInfo]
      
      def banners
        banners = []
        Direct::request("GetBanners", {:CampaignIDS => [self.CampaignID], :Currency => self.Currency}).each do |banner|
          banners << BannerInfo.new(banner)
        end
        banners
      end
      def save
        Direct::request("CreateOrUpdateCampaign", self.to_hash)
      end
      def archive
        Direct::request("ArchiveCampaign", {:CampaignID => self.CampaignID})
      end
      def unarchive
        Direct::request("UnArchiveCampaign", {:CampaignID => self.CampaignID})
      end
      def resume
        Direct::request("ResumeCampaign", {:CampaignID => self.CampaignID})
      end
      def stop
        Direct::request("StopCampaign", {:CampaignID => self.CampaignID})
      end
      def delete
        Direct::request("DeleteCampaign", {:CampaignID => self.CampaignID})
      end
      def self.find id, currency = "RUB"
        result = Direct::request("GetCampaignParams", {:CampaignID => id, :Currency=> currency})
        raise Yandex::NotFound.new("not found campaign where CampaignID = #{id}") if result.empty?
        new(result)
      end
      def self.list
        campaigs = []
        Direct::request("GetCampaignsList").each do |campaig|
          campaigs << new(campaig)
        end
        campaigs 
      end
    end
  end
end