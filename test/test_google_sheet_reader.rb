require 'minitest/autorun'
require 'google_sheet_reader'

class GoogleSheetReaderTest < Minitest::Test
  def test_missing_env_vars
    ENV.stub :fetch, "" do
      error = assert_raises GoogleSheetReader::MissingEnvVars do
        GoogleSheetReader.read('12345678')
      end

      assert_match /GOOGLE_PRIVATE_KEY/, error.message
    end
  end

  def test_bad_sheet_id
    assert_raises GoogleSheetReader::BadSheetId do
      GoogleSheetReader.read('12345678')
    end
  end

  def test_with_sample_sheet
    # Be sure to run the test with the correct env variables, this is an integration test that requires internet
    result = GoogleSheetReader.read('1Q2NdvsSECbDrdOf9-C1EhzHq__3jWW3lQWDDB0mJbd8')
    assert_equal [{"foo"=>"hey", "bar"=>"ho"}, {"foo"=>"let's", "bar"=>nil}, {"foo"=>nil, "bar"=>"go"}], result
  end
end
