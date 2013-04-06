require "httparty"
require "json"

module Imagga
  class BaseCommand
    include HTTParty
    include Imagga::Exceptions

    attr_reader :api_key, :api_secret, :base_uri

    def initialize(api_key, api_secret, base_uri)
      @api_key, @api_secret, @base_uri = api_key, api_secret, base_uri
      self.class.base_uri @base_uri
    end

    def execute(options)
      JSON.parse(self.class.post(service_path, body: args(options))).tap do |result|
        raise_if_request_failed!(result)
      end
    end
  end

  class ExtractCommand < BaseCommand
    def service_path; '/colorsearchserver.php'; end
    def args(options); ExtractOptions.new(api_key, api_secret).options(options); end
  end

  class RankCommand < ExtractCommand
    def args(options); RankOptions.new(api_key, api_secret).options(options); end
  end

  class CropCommand < BaseCommand
    def service_path; '/extractionrestserver.php'; end
    def args(options); CropOptions.new(api_key, api_secret).options(options); end
  end
end