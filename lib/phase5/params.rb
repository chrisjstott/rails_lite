require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      query_params = parse_www_encoded_form(req.query_string)
      body_params = parse_www_encoded_form(req.body)
      @params = deep_merge(query_params, (deep_merge(body_params, route_params)))
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return {} if www_encoded_form.nil?
      pairs = URI::decode_www_form(www_encoded_form)
      params_hash = {}
      pairs.each do |pair|
        key_array = parse_key(pair.first)
        value = pair.last
        new_hash = nest_hash(key_array, value)
        params_hash = deep_merge(params_hash, new_hash)
      end
      params_hash
    end

    def nest_hash(key_array, value)
      return value if key_array.empty?
      {key_array.first => nest_hash(key_array.drop(1), value)}
    end

    def deep_merge(hash1, hash2)
      hash2.each do |key, value|
        if hash1[key].nil?
          hash1[key] = value
        else
          deep_merge(hash1[key], value)
        end
      end
      hash1
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      return key.split(/\]\[|\[|\]/)
    end
  end
end
