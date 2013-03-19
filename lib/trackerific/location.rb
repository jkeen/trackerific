module Trackerific
  class Location
    def initialize(details = {})
      @address      = details[:address]
      @city         = details[:city]
      @state        = details[:state]
      @postal_code  = details[:postal_code]
      @country      = details[:country]
      
      self
    end
    
    def to_s
      [@address, @city, @state, @postal_code, @country].compact.join(" ")
    end
    
    attr_reader :address, :city, :state, :postal_code, :country
  end
end
