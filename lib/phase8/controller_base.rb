module Phase8
  class ControllerBase < Phase6::ControllerBase
    attr_accessor :flash

    def initialize(req, res, route_params = {})
      super
      @flash = Flash.new(req, res)
    end
  end

  class Flash
    def initialize(req, res)
      @flash_hash = req.cookies.find { |cookie| cookie.name == '_flash_hash'}
      #find the cookie
      #reset the cookie to nil

    end

    def [](flash_group)
      @flash_hash[flash_type]
    end

    def []=(flash_type, messages)
      @flash_hash[flash_type] = messages
      #save the cookie
    end

    def now
      #update @flash_hash directly
    end
  end


end
