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
end
