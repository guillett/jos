require 'rails_helper'

RSpec.describe Jorfcont, type: :model do
  describe '.destroy' do
    context 'with a object tree' do
      before do
        container = Jorfcont.new()

        jarticle = Jarticle.new()
        jtext = Jtext.new()
        jtext.jarticles << jarticle

        container.jtexts << jtext
        container.save()
        container.destroy
      end

      it 'destroyes all the object' do
        expect(JsectionJarticleLink.count).to eq(0)
        expect(Jarticle.count).to eq(0)
        expect(JtextJarticleLink.count).to eq(0)
        expect(Jtext.count).to eq(0)
        expect(JorfcontJtextLink.count).to eq(0)
        expect(Jorfcont.count).to eq(0)
      end
    end


  end
end
