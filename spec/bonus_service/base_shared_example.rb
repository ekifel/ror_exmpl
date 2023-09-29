shared_context 'with bonus service authentication' do
  let(:bonus_service_base_url) { 'base_url' }
  let(:bonus_service_login) { double(:bonus_service_login) }
  let(:bonus_service_password) { double(:bonus_service_password) }
  let(:bonus_service_timeout_string) { double(:bonus_service_timeout_string, to_i: bonus_service_timeout) }
  let(:bonus_service_timeout) { double(:bonus_service_timeout) }

  before do
    stub_const("#{described_class}::PATH", path)

    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('bonus_service_base_url').and_return(bonus_service_base_url)
    allow(ENV).to receive(:[]).with('bonus_service_login').and_return(bonus_service_login)
    allow(ENV).to receive(:[]).with('bonus_service_password').and_return(bonus_service_password)

    allow(RestClient::Resource)
      .to receive(:new)
      .with(
        composed_url,
        user: bonus_service_login,
        password: bonus_service_password,
        verify_ssl: false
      )
      .and_return(resource)
  end
end

shared_examples 'when bonus service rescuable from RestClient::Exception' do
  let(:resource) { instance_double(RestClient::Resource) }

  before { allow(resource).to receive(call_type).and_raise(exception) }

  context 'when error has http_code' do
    let(:exception) { RestClient::Exception.new(error_response) }
    let(:error_response) { instance_double(RestClient::Response, body: error_body.to_json, code: http_code) }
    let(:error_body) { { 'some' => 'error' } }
    let(:http_code) { 400 }

    it 'returns Error result' do
      expect(subject).to be_instance_of(Result::Error)
    end

    it 'returns result with message' do
      expect(subject.message).to eq(error_body)
    end

    it 'returns result with http_code' do
      expect(subject.http_code).to eq(http_code)
    end
  end

  context 'when error has no http_code' do
    let(:exception) { RestClient::Exception }

    it 'raises an exception' do
      expect { subject }.to raise_error(BonusService::BonusServiceException)
    end
  end
end
