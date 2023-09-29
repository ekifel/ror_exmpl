require_relative '../base_shared_example'

describe BonusService::Loyal::ClientBonuses, type: :service do
  subject { described_class }

  let(:base_path) { 'base_path' }
  let(:path) { 'path' }

  before { stub_const('BonusService::Loyal::Base::BASE_PATH', base_path) }

  include_context 'with bonus service authentication'

  describe '.fetch' do
    subject { super().fetch(account_id: account_id) }

    let(:account_id) { 123456 }
    let(:records) { 100 }

    let(:composed_url) { "#{bonus_service_base_url}/#{base_path}/#{path}?records=#{op_num}&UID=#{account_id}" }
    let(:resource) { instance_double(RestClient::Resource, get: response) }
    let(:response) { instance_double(RestClient::Response, body: response_body) }

    it_behaves_like 'when bonus service rescuable from RestClient::Exception' do
      let(:call_type) { :get }
    end

    before do
      allow(RestClient::Resource)
        .to receive(:new)
        .with(
          composed_url,
          user: bonus_service_login,
          password: bonus_service_password,
          verify_ssl: false,
          timeout: bonus_service_timeout,
          open_timeout: bonus_service_timeout
        )
        .and_return(resource)
    end

    context 'when call was successful' do
      let(:response_body) { { data: bonuses }.to_json }
      let(:bonuses) { [{ uid: account_id }].as_json }
      let(:result) { { bonuses: bonuses } }

      it 'returns Ok result' do
        expect(subject).to be_instance_of(Result::Ok)
      end

      it 'returns result with bonuses data' do
        expect(subject.data).to eq(result)
      end
    end
  end
end
