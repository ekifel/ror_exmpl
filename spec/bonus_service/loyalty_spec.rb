describe BonusService::Loyal, type: :service do
  describe '.fetch_bonuses' do
    subject { described_class.fetch_bonuses(account_id: account_id) }

    let(:account_id) { double(:account_id) }
    let(:result) { double(:fetch_bonuses_result) }

    before do
      allow(BonusService::Loyal::ClientBonuses)
        .to receive(:fetch)
        .with(account_id: account_id)
        .and_return(result)
    end

    it 'returns client info fetch result' do
      expect(subject).to eq(result)
    end
  end
end
