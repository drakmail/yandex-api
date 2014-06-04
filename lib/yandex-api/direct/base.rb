module Yandex::API::Direct
  class Base
    def self.attributes ; @attributes || [] ; end 
    def self.direct_attributes *args
      @attributes = []
      args.each do |arg|
        @attributes << arg
        self.class_eval("def #{arg};@#{arg};end")
        self.class_eval("def #{arg}=(val);@#{arg}=val;end")          
      end
    end
    def self.objects ; @objects || [] ; end 
    def self.direct_objects *args
      @objects = []
      args.each do |object,type|
        @objects << [object,type]
        self.class_eval("def #{object};@#{object};end")
        self.class_eval("def #{object}=(val);@#{object}=val;end")          
      end
    end
    def self.arrays ; @arrays || [] ; end 
    def self.direct_arrays *args
      @arrays = []
      args.each do |array,type|
        @arrays << [array,type]
        self.class_eval("def #{array};@#{array};end")
        self.class_eval("def #{array}=(val);@#{array}=val;end")          
      end
    end
    def to_hash
      result = {}
      # build hash of attributes
      self.class.attributes.each do |attribute|
        value = send(attribute)
        next if value.nil?
        result[attribute] = value
      end
      # build hash of arrays
      self.class.arrays.each do |array,type|
        data_array = send(array)|| []
        next if data_array.empty?
        result[array] = []
        data_array.each do |data|
          result[array] << data.to_hash
        end
      end
      # build hash of objects
      self.class.objects.each do |object,type|
        next if send(object).nil?
        value_hash = send(object).to_hash || {}
        next if value_hash.empty?
        result[object] = value_hash
      end
      result
    end
    def initialize(params = {})
      params.each do |key, value|
        object = self.class.objects.find{|s| s.first.to_sym == key.to_sym}
        array = self.class.arrays.find{|s| s.first.to_sym == key.to_sym}
        if object
          send("#{key}=", object.last.new(value))
        elsif array
          next if value.nil?
          send("#{key}=", value.collect {|element| array.last.new(element)})
        else
          send("#{key}=", value) if respond_to? "#{key}="
        end
      end
    end
  end
end