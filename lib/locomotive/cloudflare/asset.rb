module Locomotive
  module Cloudflare
    module Asset

      extend ActiveSupport::Concern

      module ClassMethods

        def expire_cache
          p document
        end

      end

      def expire_cache
        expire self
      end

      def expire file

        unless Locomotive.config.cloudflare.nil?
          data = {
            verify: false,
            query: {
              tkn: Locomotive.config.cloudflare_api_key,
              email: Locomotive.config.cloudflare_email,
              a: 'zone_file_purge',
              z: Locomotive.config.cloudflare_asset_domain,
              url: self.source.url
            }
          }

          begin
            HTTParty.post("https://www.cloudflare.com/api_json.html", data)
          rescue => e
              puts e.message # error message
          else
            puts self.source.url
            puts 'Successfully expired asset from cache'
          end

        end

      end

    end
  end
end
