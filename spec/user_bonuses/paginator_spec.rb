describe UserBonuses::Paginator, type: :service do
  subject { described_class }

  describe '#execute' do
    subject { super().execute(bonuses, page, limit) }

    let(:bonuses) { [bonus_1, bonus_2, bonus_3, bonus_4] }
    let(:bonus_1) { double(:bonus) }
    let(:bonus_2) { double(:bonus) }
    let(:bonus_3) { double(:bonus) }
    let(:bonus_4) { double(:bonus) }

    context 'when page is 1' do
      let(:page) { 1 }
      let(:limit) { 2 }
      let(:expected_result) { [bonus_1, bonus_2] }

      it 'returns the first page of bonuses' do
        expect(subject).to eq(expected_result)
      end
    end

    context 'when page is greater than 1' do
      let(:page) { 2 }
      let(:limit) { 2 }
      let(:expected_result) { [bonus_3, bonus_4] }

      it 'returns the requested page of bonuses' do
        expect(subject).to eq(expected_result)
      end
    end
  end
end
