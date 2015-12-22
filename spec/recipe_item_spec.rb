# -*- encoding : utf-8 -*-

PAGE_TITLE = 'foo title'
PAGE_DESC = 'bar description'
PAGE_TABLE_1 = 'ugabuga'
PAGE_TABLE_2 = 'pikachu'
PAGE_HTML = %{
  <html>
    <head>
      <title>Fake</title>
    </head>
    <body>
      <div class="container red">
        <div class="header">
          <h1 id="title">  #{PAGE_TITLE}  </h1>
          <p id="desc"> #{PAGE_DESC}  </p>
        </div>
        <table class="table table-stripped">
          <tbody>
            <tr>
              <td>1.</td>
              <td>#{PAGE_TABLE_1} </td>
            </tr>
            <tr>
              <td>2.</td>
              <td> #{PAGE_TABLE_2}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </body>
  </html>
}

describe Kabuto::RecipeItem do
  subject { described_class.new(*args) }
  let(:page) { Nokogiri::HTML(PAGE_HTML) }
  let(:meta) { { id: '123', apple: 'green' } }

  describe '#initialize' do
    let(:args) { [:var, 'value'] }

    it 'sets values' do
      expect(subject.type).to eq :var
      expect(subject.value).to eq 'value'
    end
  end

  describe '#process' do
    context ':var type' do
      let(:args) { [:var, :apple] }

      it 'returns value from meta' do
        expect(subject.process(nil, meta)).to eq 'green'
      end
    end

    context ':recipe type' do
      let(:args) { [:recipe, recipe] }
      let(:recipe) { double('recipe') }

      it 'delegetes arguments' do
        args = [:a1, :a2]
        expect(recipe).to receive(:process).with(*args)
        subject.process(*args)
      end
    end

    context ':css type' do
      let(:args) { [:css, '.container > .header > h1#title'] }

      it 'returns title' do
        expect(subject.process(page, nil)).to eq PAGE_TITLE
      end

      context 'invalid value' do
        let(:args) { [:css, '.blabla'] }

        it 'returns empty string' do
          expect(subject.process(page, nil)).to eq ''
        end
      end
    end

    context ':xpath type' do
      let(:args) { [:xpath, '//table/tbody/tr[2]/td[2]'] }

      it 'returns value of second row of table' do
        expect(subject.process(page, nil)).to eq PAGE_TABLE_2
      end

      context 'invalid value' do
        let(:args) { [:xpath, '//blabla'] }

        it 'returns empty string' do
          expect(subject.process(page, nil)).to eq ''
        end
      end
    end

    context ':lambda type' do
      let(:lambda) { double(:lambda) }
      let(:args) { [:lambda, lambda] }

      it 'passes arguments to lambda' do
        expect(lambda).to receive(:call).with(page, meta)
        subject.process(page, meta)
      end
    end

    context ':proc type' do
      let(:proc) { double(:proc) }
      let(:args) { [:proc, proc] }

      it 'passes arguments to proc' do
        expect(proc).to receive(:call).with(page, meta)
        subject.process(page, meta)
      end
    end

    context ':const type' do
      let(:args) { [:const, 'foo'] }

      it 'returns constant' do
        expect(subject.process(nil, nil)).to eq 'foo'
      end
    end

    context ':unkwown type' do
      it 'raises exception' do
        expect{
          Kabuto::RecipeItem.new(:unknown, :whatever)
        }.to raise_error
      end
    end

    context 'conversion to int' do
      let(:args) { [:const, 'bbb123aaa', :int] }

      it 'converts value to int' do
        expect(subject.process(nil, nil)).to eq 123
      end
    end

    context 'conversion to float' do
      let(:args) { [:const, 'bbb123,123aaa', :float] }

      it 'converts value to float' do
        expect(subject.process(nil, nil)).to eq 123.123
      end
    end

    context 'invalid conversion' do
      let(:args) { [:const, 'bar', :foo] }

      it 'converts value to float' do
        expect{
          subject.process(nil, nil)
        }.to raise_error
      end
    end
  end
end
