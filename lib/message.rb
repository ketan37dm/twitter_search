class Message
  API_RATE_LIMIT = 450
  POSTS_PER_API_CALL = 100

  def initialize(hash_tag, number_of_posts)
    @hash_tag = hash_tag
    @number_of_posts = number_of_posts
    @current_post_count = 0
  end

  def get_message_file
    status, errors = valid_data?
    unless status
      puts errors.to_s
      return
    end
    response = get_response_from_twitter
    file_path = store_response(response)
    file_path
  rescue StandardError => e
    puts "#{e.class} - #{e.message}"
  end

  private

  def get_twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "3B0Cg3sf5C50GQQ6IyDeQQ"
      config.consumer_secret     = "4R6ZVjeE3T1B69ZsbrbBhn42KVGek0KRZm6yjDlRrY"
      config.access_token        = "127274227-b77OaV9AITfMGZFDhsIiFBTKeTDLpsSpJt7KeB4"
      config.access_token_secret = "pQGOLhwl4QKKCgfWq987hLs0T9pbQtl2jhMq144a4"
    end
  end

  def get_response_from_twitter
    client = get_twitter_client
    all_responses = []
    max_id = nil
    while(@current_post_count < @number_of_posts)
      attributes = {
        result_type: 'recent',
        count: get_current_count
      }
      attributes.merge!({'max_id' => max_id}) if max_id
      response = client.search(@hash_tag, attributes)
      max_id = response.attrs[:search_metadata][:max_id]
      all_responses << response
      @current_post_count += get_current_count
    end
    all_responses.flatten.compact
  end

  def store_response(response)
    file_path = Rails.root.to_s + "/" + @hash_tag.gsub('#', '') + "_#{Time.now.to_i}.txt"
    File.open(file_path, 'wb') { |fd| fd.write(response) }
    file_path
  end

  def get_current_count
    [(@number_of_posts - @current_post_count), 100].min
  end

  def valid_data?
    errors = []
    errors << "Hash Tag should be a string" unless @hash_tag.instance_of?(String)
    errors << "Hash Tag should begin with `#` character e.g. `#tint`" if @hash_tag.instance_of?(String) && @hash_tag[0] != '#'
    errors << "Number of Posts parameter needs to an integer above 0" unless valid_number_of_posts?
    return [false, errors] if errors.present?
    max_posts = API_RATE_LIMIT * POSTS_PER_API_CALL
    errors << "API limit exceeds. Maximum allowed value is #{max_posts}" if @number_of_posts > API_RATE_LIMIT * POSTS_PER_API_CALL
    return [false, errors] if errors.present?
    return [true, nil]
  end

  def valid_number_of_posts?
    @number_of_posts && @number_of_posts.is_a?(Integer) && @number_of_posts >= 0
  end
end
