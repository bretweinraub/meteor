require 'net/http'
require 'net/https'
require 'open-uri'
require 'hpricot'
require 'ruby-debug'

module Meteor
  module Widget
    module RemoteContent
      class Renderer < ::Meteor::RendererBase
        
        def content
          response = Net::HTTP.get_response(URI::parse(spec.url))
          if response
            response_code = response.code
            response_code = "999" if response.body =~ /\AERROR:/
            if response_code == "200"
              return absolutize(spec.url, response.body, spec.remote_dom_id, spec.partial)
            else
              return "Made request to #{spec.url}, got response code #{response_code}" + (response_code == "999" ? "\n#{response.body}" : "")
            end
          else
            return "Error getting response for URL #{spec.url}"
          end
        end
        
        def absolutize(url, body, remote_dom_id = nil, partial = nil)
          document = Hpricot(body)
          (document/"img").each do |img|
            source = img.attributes['src']
            if source !~ /\Ahttp:\/\//
              img.attributes['src'] = "#{url}" + source
            end
          end
          (document/"script").each do |script|
            source = script.attributes['src']
            if source !~ /\Ahttp:\/\//
              script.attributes['src'] = "#{url}" + source
            end
          end
          (document/"link").each do |link|
            href = link.attributes['href']
            if href !~ /\Ahttp:\/\//
              link.attributes['href'] = "#{url}" + href
            end
          end
          (document/"a").each do |a|
            href = a.attributes['href']
            if href !~ /\Ahttp:\/\//
              a.attributes['href'] = "#{url}" + href
            end
          end
          (document/"form").each do |form|
            action = form.attributes['action']
            if action !~ /\Ahttp:\/\//
              form.attributes['action'] = "#{url}" + action
            end
          end
          (document/(remote_dom_id)).first.inner_html = @template.render(:partial => partial) if remote_dom_id && partial
          return (document/"head").first.to_s + (document/"body").first.to_s
        end
        
      end
    end
  end
end
