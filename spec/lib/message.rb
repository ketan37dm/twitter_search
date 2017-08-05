require 'rails_helper'
require "#{Rails.root}/lib/message.rb"

RSpec.describe Message, type: :model do
  describe '#valid_number_of_posts?' do
    context 'invalid input' do
      it 'should return false for non-integer or negative values' do
        [-10, 'tint', 0.123].each do |value|
          message = Message.new(nil, value)
          status = message.send(:valid_number_of_posts?)
          expect(status).to eq(false)
        end
      end
    end

    context 'valid input' do
      it 'should return true for valid positive integer' do
        message = Message.new(nil, 1233)
        status = message.send(:valid_number_of_posts?)
        expect(status).to eq(true)
      end
    end
  end

  describe '#valid_data?' do
    context 'invalid input' do
      it 'should return errors for nil data' do
        message = Message.new(nil, nil)
        status, errors = message.send(:valid_data?)
        expect(status).to eq(false)
        expect(errors).to eq(["Hash Tag should be a string", "Number of Posts parameter needs to an integer above 0"])
      end

      it 'should return errors for absence of `#` hashtag' do
        message = Message.new('tint', 1223)
        status, errors = message.send(:valid_data?)
        expect(status).to eq(false)
        expect(errors).to eq(["Hash Tag should begin with `#` character e.g. `#tint`"])
      end

      it 'should return errors if API rate limit is being exceeded' do
        message = Message.new('#tint', 100000)
        max_posts = Message::API_RATE_LIMIT * Message::POSTS_PER_API_CALL
        status, errors = message.send(:valid_data?)
        expect(status).to eq(false)
        expect(errors).to eq(["API limit exceeds. Maximum allowed value is #{max_posts}"])
      end
    end

    context 'valid_input' do
      it 'should return true with no errors' do
        message = Message.new('#tint', 1234)
        status, errors = message.send(:valid_data?)
        expect(status).to eq(true)
        expect(errors).to eq(nil)
      end
    end
  end

  describe '#get_message_file' do
    it 'should return file_path when no errors' do
      message = Message.new('#tint', 1234)
      allow(message).to receive(:get_response_from_twitter).and_return(search_response)
      result = message.get_message_file
      expect(result).not_to eq(nil)
    end
  end
end

def search_response
  '[#<Twitter::SearchResults:0x007ffba97cb5f8 @client=#<Twitter::REST::Client:0x007ffbaf0082e8 @consumer_key="3B0Cg3sf5C50GQQ6IyDeQQ", @consumer_secret="4R6ZVjeE3T1B69ZsbrbBhn42KVGek0KRZm6yjDlRrY", @access_token="127274227-b77OaV9AITfMGZFDhsIiFBTKeTDLpsSpJt7KeB4", @access_token_secret="pQGOLhwl4QKKCgfWq987hLs0T9pbQtl2jhMq144a4", @middleware=#<Faraday::RackBuilder:0x007ffbaf003f90 @handlers=[Twitter::REST::Request::MultipartWithFile, Faraday::Request::Multipart, Faraday::Request::UrlEncoded, Twitter::REST::Response::RaiseError, Twitter::REST::Response::ParseJson, Faraday::Adapter::NetHttp], @app=#<Twitter::REST::Request::MultipartWithFile:0x007ffba97d0be8 @app=#<Faraday::Request::Multipart:0x007ffba97d0c38 @app=#<Faraday::Request::UrlEncoded:0x007ffba97d0d50 @app=#<Twitter::REST::Response::RaiseError:0x007ffba97d0df0 @app=#<Twitter::REST::Response::ParseJson:0x007ffba97d0e40 @app=#<Faraday::Adapter::NetHttp:0x007ffba97d0f08 @app=#<Proc:0x007ffba97d1048@/Users/ketandeshmukh/.rvm/gems/ruby-2.1.2@instasearch/gems/faraday-0.11.0/lib/faraday/rack_builder.rb:152 (lambda)>, @connection_options={}, @config_block=nil>>>>>>>, @user_agent="TwitterRubyGem/6.1.0", @connection_options={:builder=>#<Faraday::RackBuilder:0x007ffbaf003f90 @handlers=[Twitter::REST::Request::MultipartWithFile, Faraday::Request::Multipart, Faraday::Request::UrlEncoded, Twitter::REST::Response::RaiseError, Twitter::REST::Response::ParseJson, Faraday::Adapter::NetHttp], @app=#<Twitter::REST::Request::MultipartWithFile:0x007ffba97d0be8 @app=#<Faraday::Request::Multipart:0x007ffba97d0c38 @app=#<Faraday::Request::UrlEncoded:0x007ffba97d0d50 @app=#<Twitter::REST::Response::RaiseError:0x007ffba97d0df0 @app=#<Twitter::REST::Response::ParseJson:0x007ffba97d0e40 @app=#<Faraday::Adapter::NetHttp:0x007ffba97d0f08 @app=#<Proc:0x007ffba97d1048@/Users/ketandeshmukh/.rvm/gems/ruby-2.1.2@instasearch/gems/faraday-0.11.0/lib/faraday/rack_builder.rb:152 (lambda)>, @connection_options={}, @config_block=nil>>>>>>>, :headers=>{:accept=>"application/json", :user_agent=>"TwitterRubyGem/6.1.0"}, :request=>{:open_timeout=>10, :timeout=>30}, :proxy=>nil}, @connection=#<Faraday::Connection:0x007ffba97d91f8 @parallel_manager=nil, @headers={"Accept"=>"application/json", "User-Agent"=>"TwitterRubyGem/6.1.0"}, @params={}, @options=#<Faraday::RequestOptions timeout=30, open_timeout=10>, @ssl=#<Faraday::SSLOptions verify=true>, @default_parallel_manager=nil, @builder=#<Faraday::RackBuilder:0x007ffbaf003f90 @handlers=[Twitter::REST::Request::MultipartWithFile, Faraday::Request::Multipart, Faraday::Request::UrlEncoded, Twitter::REST::Response::RaiseError, Twitter::REST::Response::ParseJson, Faraday::Adapter::NetHttp], @app=#<Twitter::REST::Request::MultipartWithFile:0x007ffba97d0be8 @app=#<Faraday::Request::Multipart:0x007ffba97d0c38 @app=#<Faraday::Request::UrlEncoded:0x007ffba97d0d50 @app=#<Twitter::REST::Response::RaiseError:0x007ffba97d0df0 @app=#<Twitter::REST::Response::ParseJson:0x007ffba97d0e40 @app=#<Faraday::Adapter::NetHttp:0x007ffba97d0f08 @app=#<Proc:0x007ffba97d1048@/Users/ketandeshmukh/.rvm/gems/ruby-2.1.2@instasearch/gems/faraday-0.11.0/lib/faraday/rack_builder.rb:152 (lambda)>, @connection_options={}, @config_block=nil>>>>>>>, @url_prefix=#<URI::HTTPS:0x007ffba97d8e38 URL:https://api.twitter.com/>, @proxy=nil>>, @request_method=:get, @path="/1.1/search/tweets.json", @options={:result_type=>"recent", :count=>1, :q=>"#tint"}, @collection=[#<Twitter::Tweet id=893772748090073088>], @attrs={:statuses=>[{:created_at=>"Sat Aug 05 09:56:43 +0000 2017", :id=>893772748090073088, :id_str=>"893772748090073088", :text=>"RT @scstationary: ฉลองเปิดร้านใหม่😆👏\u{1F3FC} สุ่มแจกเมื่อยอดฟอลครบ500 ค่ะ รีกันเยอะๆนะคะ😊 #แจกของ #พื้นที่แจกของ #etude #tint https://t.co/s7RjUts…", :truncated=>false, :entities=>{:hashtags=>[{:text=>"แจกของ", :indices=>[83, 90]}, {:text=>"พื้นที่แจกของ", :indices=>[91, 105]}, {:text=>"etude", :indices=>[106, 112]}, {:text=>"tint", :indices=>[113, 118]}], :symbols=>[], :user_mentions=>[{:screen_name=>"scstationary", :name=>"sc.คสอพร้อมส่ง✨", :id=>832859754380697600, :id_str=>"832859754380697600", :indices=>[3, 16]}], :urls=>[]}, :metadata=>{:iso_language_code=>"th", :result_type=>"recent"}, :source=>"<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>", :in_reply_to_status_id=>nil, :in_reply_to_status_id_str=>nil, :in_reply_to_user_id=>nil, :in_reply_to_user_id_str=>nil, :in_reply_to_screen_name=>nil, :user=>{:id=>925359872, :id_str=>"925359872", :name=>"แบ็ม นาริซ", :screen_name=>"Antiz_Love", :location=>"", :description=>"", :url=>nil, :entities=>{:description=>{:urls=>[]}}, :protected=>false, :followers_count=>212, :friends_count=>74, :listed_count=>0, :created_at=>"Sun Nov 04 13:31:26 +0000 2012", :favourites_count=>8540, :utc_offset=>25200, :time_zone=>"Bangkok", :geo_enabled=>true, :verified=>false, :statuses_count=>34873, :lang=>"th", :contributors_enabled=>false, :is_translator=>false, :is_translation_enabled=>false, :profile_background_color=>"642D8B", :profile_background_image_url=>"http://pbs.twimg.com/profile_background_images/613964242778112001/JEtt5JAV.jpg", :profile_background_image_url_https=>"https://pbs.twimg.com/profile_background_images/613964242778112001/JEtt5JAV.jpg", :profile_background_tile=>true, :profile_image_url=>"http://pbs.twimg.com/profile_images/887714581090516996/zsMYnr1E_normal.jpg", :profile_image_url_https=>"https://pbs.twimg.com/profile_images/887714581090516996/zsMYnr1E_normal.jpg", :profile_banner_url=>"https://pbs.twimg.com/profile_banners/925359872/1500835330", :profile_link_color=>"FF0000", :profile_sidebar_border_color=>"000000", :profile_sidebar_fill_color=>"000000", :profile_text_color=>"000000", :profile_use_background_image=>true, :has_extended_profile=>true, :default_profile=>false, :default_profile_image=>false, :following=>false, :follow_request_sent=>false, :notifications=>false, :translator_type=>"none"}, :geo=>nil, :coordinates=>nil, :place=>nil, :contributors=>nil, :retweeted_status=>{:created_at=>"Sun Jul 16 11:41:03 +0000 2017", :id=>886551247075004416, :id_str=>"886551247075004416", :text=>"ฉลองเปิดร้านใหม่😆👏\u{1F3FC} สุ่มแจกเมื่อยอดฟอลครบ500 ค่ะ รีกันเยอะๆนะคะ😊 #แจกของ #พื้นที่แจกของ #etude #tint https://t.co/s7RjUtst0b", :truncated=>false, :entities=>{:hashtags=>[{:text=>"แจกของ", :indices=>[65, 72]}, {:text=>"พื้นที่แจกของ", :indices=>[73, 87]}, {:text=>"etude", :indices=>[88, 94]}, {:text=>"tint", :indices=>[95, 100]}], :symbols=>[], :user_mentions=>[], :urls=>[], :media=>[{:id=>886551229773389824, :id_str=>"886551229773389824", :indices=>[101, 124], :media_url=>"http://pbs.twimg.com/media/DE2ppXXUIAAvZSw.jpg", :media_url_https=>"https://pbs.twimg.com/media/DE2ppXXUIAAvZSw.jpg", :url=>"https://t.co/s7RjUtst0b", :display_url=>"pic.twitter.com/s7RjUtst0b", :expanded_url=>"https://twitter.com/scstationary/status/886551247075004416/photo/1", :type=>"photo", :sizes=>{:large=>{:w=>749, :h=>815, :resize=>"fit"}, :medium=>{:w=>749, :h=>815, :resize=>"fit"}, :small=>{:w=>625, :h=>680, :resize=>"fit"}, :thumb=>{:w=>150, :h=>150, :resize=>"crop"}}}]}, :extended_entities=>{:media=>[{:id=>886551229773389824, :id_str=>"886551229773389824", :indices=>[101, 124], :media_url=>"http://pbs.twimg.com/media/DE2ppXXUIAAvZSw.jpg", :media_url_https=>"https://pbs.twimg.com/media/DE2ppXXUIAAvZSw.jpg", :url=>"https://t.co/s7RjUtst0b", :display_url=>"pic.twitter.com/s7RjUtst0b", :expanded_url=>"https://twitter.com/scstationary/status/886551247075004416/photo/1", :type=>"photo", :sizes=>{:large=>{:w=>749, :h=>815, :resize=>"fit"}, :medium=>{:w=>749, :h=>815, :resize=>"fit"}, :small=>{:w=>625, :h=>680, :resize=>"fit"}, :thumb=>{:w=>150, :h=>150, :resize=>"crop"}}}, {:id=>886551229777682432, :id_str=>"886551229777682432", :indices=>[101, 124], :media_url=>"http://pbs.twimg.com/media/DE2ppXYVoAAyyqe.jpg", :media_url_https=>"https://pbs.twimg.com/media/DE2ppXYVoAAyyqe.jpg", :url=>"https://t.co/s7RjUtst0b", :display_url=>"pic.twitter.com/s7RjUtst0b", :expanded_url=>"https://twitter.com/scstationary/status/886551247075004416/photo/1", :type=>"photo", :sizes=>{:small=>{:w=>442, :h=>680, :resize=>"fit"}, :thumb=>{:w=>150, :h=>150, :resize=>"crop"}, :medium=>{:w=>749, :h=>1152, :resize=>"fit"}, :large=>{:w=>749, :h=>1152, :resize=>"fit"}}}, {:id=>886551229748322304, :id_str=>"886551229748322304", :indices=>[101, 124], :media_url=>"http://pbs.twimg.com/media/DE2ppXRVoAAMB1f.jpg", :media_url_https=>"https://pbs.twimg.com/media/DE2ppXRVoAAMB1f.jpg", :url=>"https://t.co/s7RjUtst0b", :display_url=>"pic.twitter.com/s7RjUtst0b", :expanded_url=>"https://twitter.com/scstationary/status/886551247075004416/photo/1", :type=>"photo", :sizes=>{:large=>{:w=>749, :h=>1166, :resize=>"fit"}, :small=>{:w=>437, :h=>680, :resize=>"fit"}, :thumb=>{:w=>150, :h=>150, :resize=>"crop"}, :medium=>{:w=>749, :h=>1166, :resize=>"fit"}}}]}, :metadata=>{:iso_language_code=>"th", :result_type=>"recent"}, :source=>"<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>", :in_reply_to_status_id=>nil, :in_reply_to_status_id_str=>nil, :in_reply_to_user_id=>nil, :in_reply_to_user_id_str=>nil, :in_reply_to_screen_name=>nil, :user=>{:id=>832859754380697600, :id_str=>"832859754380697600", :name=>"sc.คสอพร้อมส่ง✨", :screen_name=>"scstationary", :location=>"", :description=>"คสอเกาหลีของแท้💯 พร้อมส่ง|พรี [ปิดรอบทุกวันอาทิตย์] รอของ 15-20 วัน 📮ลทบ40/ems60 สินค้าดูใน ❤️ ค่ะ | สนใจเมนชั่น/dmเล๊ยย 🎀| เราใจดีนะ ทักมาถามได้ตลอดค่ะ 😊", :url=>nil, :entities=>{:description=>{:urls=>[]}}, :protected=>false, :followers_count=>75, :friends_count=>8, :listed_count=>0, :created_at=>"Sat Feb 18 07:50:14 +0000 2017", :favourites_count=>51, :utc_offset=>nil, :time_zone=>nil, :geo_enabled=>false, :verified=>false, :statuses_count=>104, :lang=>"en", :contributors_enabled=>false, :is_translator=>false, :is_translation_enabled=>false, :profile_background_color=>"F5F8FA", :profile_background_image_url=>nil, :profile_background_image_url_https=>nil, :profile_background_tile=>false, :profile_image_url=>"http://pbs.twimg.com/profile_images/887286628590342144/kyRtqtpr_normal.jpg", :profile_image_url_https=>"https://pbs.twimg.com/profile_images/887286628590342144/kyRtqtpr_normal.jpg", :profile_banner_url=>"https://pbs.twimg.com/profile_banners/832859754380697600/1501142785", :profile_link_color=>"1DA1F2", :profile_sidebar_border_color=>"C0DEED", :profile_sidebar_fill_color=>"DDEEF6", :profile_text_color=>"333333", :profile_use_background_image=>true, :has_extended_profile=>false, :default_profile=>true, :default_profile_image=>false, :following=>false, :follow_request_sent=>false, :notifications=>false, :translator_type=>"none"}, :geo=>nil, :coordinates=>nil, :place=>nil, :contributors=>nil, :is_quote_status=>false, :retweet_count=>84, :favorite_count=>10, :favorited=>false, :retweeted=>false, :possibly_sensitive=>false, :lang=>"th"}, :is_quote_status=>false, :retweet_count=>84, :favorite_count=>0, :favorited=>false, :retweeted=>false, :lang=>"th"}], :search_metadata=>{:completed_in=>0.052, :max_id=>893772748090073088, :max_id_str=>"893772748090073088", :next_results=>"?max_id=893772748090073087&q=%23tint&count=1&include_entities=1&result_type=recent", :query=>"%23tint", :refresh_url=>"?since_id=893772748090073088&q=%23tint&result_type=recent&include_entities=1", :count=>1, :since_id=>0, :since_id_str=>"0"}}>]'
end
