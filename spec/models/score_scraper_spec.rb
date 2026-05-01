# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoreScraper, type: :model do
  let(:url) { 'https://baseball.yahoo.co.jp/npb/teams/6/memberlist' }
  let(:charset) { 'utf-8' }
  let(:mock_file) { double('http_response', charset: charset, read: html_content) }

  before do
    allow(URI).to receive(:open).with(url).and_yield(mock_file)
  end

  subject(:scraper) { described_class.new(url) }

  def build_table(rows_html)
    "<html><body><table id='js-playerTable'>#{rows_html}</table></body></html>"
  end

  describe '#scrape' do
    context 'リンクを含むセルがある場合' do
      let(:html_content) do
        build_table(<<~HTML)
          <tr>
            <td><a href="/npb/player/1/top">鈴木 誠也</a></td>
            <td>0.317</td>
          </tr>
        HTML
      end

      it 'hrefとテキストの両方をデータに含める' do
        result = scraper.scrape
        expect(result.first).to include('/npb/player/1/top', '鈴木 誠也', '0.317')
      end

      it 'hrefがテキストより先にデータに追加される' do
        result = scraper.scrape
        href_index = result.first.index('/npb/player/1/top')
        text_index = result.first.index('鈴木 誠也')
        expect(href_index).to be < text_index
      end
    end

    context 'リンクを含まないセルのみの場合' do
      let(:html_content) do
        build_table(<<~HTML)
          <tr>
            <td>18</td>
            <td>2.09</td>
          </tr>
        HTML
      end

      it 'テキストのみをデータに含める' do
        result = scraper.scrape
        expect(result.first).to eq %w[18 2.09]
      end
    end

    context 'テキストに改行が含まれる場合' do
      let(:html_content) do
        build_table(<<~HTML)
          <tr>
            <td>前田\n健太</td>
          </tr>
        HTML
      end

      it '改行を除去する' do
        result = scraper.scrape
        expect(result.first.first).to eq '前田健太'
      end
    end

    context 'テキストの左側に空白がある場合' do
      let(:html_content) do
        build_table(<<~HTML)
          <tr>
            <td>   先頭空白</td>
          </tr>
        HTML
      end

      it '左側の空白を除去する' do
        result = scraper.scrape
        expect(result.first.first).to eq '先頭空白'
      end
    end

    context 'tdが存在しない空行がある場合' do
      let(:html_content) do
        build_table(<<~HTML)
          <tr></tr>
          <tr>
            <td>1</td>
          </tr>
        HTML
      end

      it '空行はスキップする' do
        result = scraper.scrape
        expect(result.length).to eq 1
      end
    end

    context '複数行が存在する場合' do
      let(:html_content) do
        build_table(<<~HTML)
          <tr><td>1</td></tr>
          <tr><td>2</td></tr>
          <tr><td>3</td></tr>
        HTML
      end

      it '全行のデータを返す' do
        result = scraper.scrape
        expect(result.length).to eq 3
      end
    end

    context '#js-playerTableが存在しない場合' do
      let(:html_content) { '<html><body><p>テーブルなし</p></body></html>' }

      it '空配列を返す' do
        expect(scraper.scrape).to eq []
      end
    end

    context 'テーブルにデータ行が存在しない場合' do
      let(:html_content) { build_table('') }

      it '空配列を返す' do
        expect(scraper.scrape).to eq []
      end
    end
  end

  describe '#initialize (html取得)' do
    context 'HTTPリクエストが成功する場合' do
      let(:html_content) { '<html><body></body></html>' }

      it 'charsetを取得して設定する' do
        scraper
        expect(scraper.instance_variable_get(:@charset)).to eq 'utf-8'
      end

      it 'HTMLコンテンツを取得する' do
        scraper
        expect(scraper.instance_variable_get(:@html)).to eq html_content
      end
    end

    context 'OpenURI::HTTPErrorが発生する場合' do
      let(:html_content) { '' }

      before do
        allow(Kernel).to receive(:sleep)
        call_count = 0
        allow(URI).to receive(:open).with(url) do
          call_count += 1
          raise OpenURI::HTTPError.new('503 Service Unavailable', StringIO.new)
        end
      end

      it '3回リトライ後に例外を発生させる' do
        expect { described_class.new(url) }.to raise_error(OpenURI::HTTPError)
      end

      it 'URI.openを3回呼び出す' do
        expect(URI).to receive(:open).with(url).exactly(3).times
          .and_raise(OpenURI::HTTPError.new('503', StringIO.new))
        expect { described_class.new(url) }.to raise_error(OpenURI::HTTPError)
      end
    end

    context '1回失敗して2回目で成功する場合' do
      let(:html_content) { '<html><body></body></html>' }

      before do
        allow(Kernel).to receive(:sleep)
        attempt = 0
        allow(URI).to receive(:open).with(url) do |&block|
          attempt += 1
          if attempt == 1
            raise OpenURI::HTTPError.new('503', StringIO.new)
          else
            block.call(mock_file)
          end
        end
      end

      it 'リトライ後に正常にHTMLを取得する' do
        expect { described_class.new(url) }.not_to raise_error
      end
    end
  end
end
