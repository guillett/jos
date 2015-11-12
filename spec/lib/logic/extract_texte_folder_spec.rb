require 'rails_helper'
require './lib/logic/extract'

describe 'extraction of text folders' do

  before do
    @extractor = Extractor.new()
  end

  LEGI_ROOT_PATH = './spec/lib/logic/legi/'

  describe 'with a directory with 3 text folder' do
    it "extracts text folders" do
      expect(@extractor.extract_text_folder_paths(LEGI_ROOT_PATH).length).to eq(3)
    end

  end

end