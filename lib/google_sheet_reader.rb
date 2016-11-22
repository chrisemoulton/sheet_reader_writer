require 'google/apis/sheets_v4'
require 'googleauth'
require 'google_sheet_reader/errors'

module GoogleSheetReader
  REQUIRED_ENV_VARS = %w[GOOGLE_CLIENT_EMAIL
                         GOOGLE_ACCOUNT_TYPE
                         GOOGLE_PRIVATE_KEY]

  # Fetches the content of a google spreadsheet
  #
  # Example:
  #   >> GoogleSheetReader.read("1ukhJwquqRTgfX-G-nxV6AsAH726TOsKQpPJfpqNjWGg")
  #   => [{"foo"=>"hey", "bar"=>"ho"},
  #       {"foo"=>"let's ", "bar"=>"go"}]
  #
  # Arguments:
  #   sheet_id: (String) The google sheet identifier.
  #   sheet_name: (String) The sheet name, by default it's the first one

  def self.read(sheet_id, sheet_name = "")
    raise MissingEnvVars unless required_env_vars?

    begin
      sheets = Google::Apis::SheetsV4::SheetsService.new
      scopes =  ['https://www.googleapis.com/auth/spreadsheets.readonly']
      sheets.authorization = Google::Auth.get_application_default(scopes)
      raw_values = sheets.get_spreadsheet_values(sheet_id, "#{sheet_name}!A:ZZ").values
    rescue Google::Apis::ClientError => e
      raise BadSheetId if e.message =~ /notFound/
    rescue
      raise Error
    end

    rows_as_hashes(raw_values)
  end

  private

  def self.rows_as_hashes(rows)
    keys, *rest = rows

    rest.map do |row|
      Hash[keys.zip(convery_empty_cells_to_nil(row))]
    end
  end

  def self.convery_empty_cells_to_nil(row)
    row.map do |cell|
      if cell.strip == ""
        nil
      else
        cell
      end
    end
  end

  def self.required_env_vars?
    REQUIRED_ENV_VARS.all? do |e|
      ENV.has_key?(e) &&
      ENV.fetch(e) &&
      ENV.fetch(e).strip != ""
    end
  end
end
