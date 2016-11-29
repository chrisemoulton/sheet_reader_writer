require 'minitest/autorun'
require 'sheet_reader'

class SheetReaderTest < Minitest::Test
  def test_missing_env_vars
    ENV.stub :fetch, "" do
      error = assert_raises SheetReader::MissingEnvVars do
        SheetReader.read('12345678')
      end

      assert_match /GOOGLE_PRIVATE_KEY/, error.message
    end
  end

  def test_bad_sheet_id
    assert_raises SheetReader::BadSheetId do
      SheetReader.read('12345678')
    end
  end

  def test_with_sample_sheet
    # Be sure to run the test with the correct env variables, this is an integration test that requires internet
    result = SheetReader.read('1Q2NdvsSECbDrdOf9-C1EhzHq__3jWW3lQWDDB0mJbd8')
    assert_equal [{"foo"=>"hey", "bar"=>"ho"}, {"foo"=>"let's", "bar"=>nil}, {"foo"=>nil, "bar"=>"go"}], result
  end

  def test_with_unauthorized_sheet
    assert_raises SheetReader::Unauthorized do
      result = SheetReader.read('1Q732RcSCYJpWZZtnKx4yXVQTgjSEbilJKznsOp-qlPE')
    end
  end
end
