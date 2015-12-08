require 'rails_helper'
require './lib/logic/extract_jorf2'
require './lib/logic/map/legiscta_map'
require './lib/logic/map/jorf/jstruct_map'
require './lib/logic/map/jorf/jarticle_map'
require './lib/logic/map/jorf/jscta_map'
require './lib/logic/map/jorf/link_jtext_jarticle_map'

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

    describe '#extract_all_articles_from_a_jtext_map' do

      before do
        @jsection_store = {}

        allow(extractor).to receive(:find_article_map_by_id_origin) do |id_jarticle_origin|
          jarticle_map = JarticleMap.new
          jarticle_map.id_jarticle_origin = id_jarticle_origin
          jarticle_map
        end

        allow(extractor).to receive(:find_jscta_map_by_id_origin) do |id_jsection_origin|
          @jsection_store[id_jsection_origin]
        end
      end

      def create_section options
        jsection_map = JsctaMap.new()
        jsection_map.link_section_article_maps=[]
        jsection_map.link_section_maps=[]

        if !options[:linked_to_article_id].nil?
          link_jsection_jarticle_map = LinkJsectionJarticleMap.new()
          link_jsection_jarticle_map.id_jarticle_origin = options[:linked_to_article_id]
          jsection_map.link_section_article_maps = [link_jsection_jarticle_map]
        end

        if !options[:linked_to_section_id].nil?
          link_jsection_map = LinkJsectionMap.new()
          link_jsection_map.id_jsection_origin= options[:linked_to_section_id]
          jsection_map.link_section_maps = [link_jsection_map]
        end

        @jsection_store[options[:id]] = jsection_map
      end

      def create_text_section_link id_section
        link_jtext_jsection_map = LinkJtextJsectionMap.new()
        link_jtext_jsection_map.id_jsection_origin= id_section
        jstruct_map.link_text_section_maps << link_jtext_jsection_map
      end

      let(:jstruct_map) { jstruct = JstructMap.new(); jstruct.link_text_section_maps = []; jstruct }
      let(:articles) { extractor.extract_all_article_map_from_jstruct_map(jstruct_map, '') }

      context 'with articles directly attached to jtext' do
        before do
          link_jtext_jarticle_map = LinkJtextJarticleMap.new()
          link_jtext_jarticle_map.id_jarticle_origin = 'lvl_0'
          jstruct_map.link_text_article_maps = [link_jtext_jarticle_map]
        end

        it 'returns thoses articles' do
          expect(articles.length).to eq(1)
          expect(articles[0].id_jarticle_origin).to eq('lvl_0')
        end
      end

      context 'with articles attached to a first level section' do
        before do
          create_section(id: 's1', linked_to_article_id: 'lvl1')
          create_text_section_link 's1'
        end

        it 'returns thoses articles' do
          expect(articles.length).to eq(1)
          expect(articles[0].id_jarticle_origin).to eq('lvl1')
        end

      end

      context 'with articles attached to a second level section' do
        before do
          create_section(id: 's2', linked_to_article_id: 'lvl2')
          create_section(id: 's1', linked_to_section_id: 's2')
          create_text_section_link 's1'
        end

        it 'returns thoses articles' do
          expect(articles.length).to eq(1)
          expect(articles[0].id_jarticle_origin).to eq('lvl2')
        end

      end

      context 'with articles on level 0,1,2' do
        before do
          link_jtext_jarticle_map = LinkJtextJarticleMap.new()
          link_jtext_jarticle_map.id_jarticle_origin = 'lvl_0'
          jstruct_map.link_text_article_maps = [link_jtext_jarticle_map]

          create_section(id: 's1.1', linked_to_article_id: 'lvl_2')
          create_section(id: 's1', linked_to_section_id: 's1.1')
          create_text_section_link 's1'

          create_section(id: 's2', linked_to_article_id: 'lvl_1')
          create_text_section_link 's2'
        end

        it 'returns all the articles' do
          puts articles.inspect
          expect(articles.length).to eq(3)
        end

      end

    end

  end

end
