require 'rails_helper'
require './lib/logic/extract_jorf2'
require './lib/logic/map/legiscta_map'

describe 'extraction of text folders' do

  describe 'Extractor' do

    let(:extractor) { Extractor.new }

    describe '#dirname_from_id_origin' do
      context 'with JORFTEXT000000158197' do
        let(:input) { "JORFTEXT000000158197" }

        it { expect(extractor.dirname_from_id_origin(input)).to eq('00/00/00/15/81') }
      end

      context 'with JORFTEXT000000870004' do
        let(:input) { "JORFTEXT000000870004" }

        it { expect(extractor.dirname_from_id_origin(input)).to eq('00/00/00/87/00') }
      end
    end

  end

end
