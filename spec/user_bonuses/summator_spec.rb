describe UserBonuses::Summator, type: :service do
  subject { described_class }

  describe '#amounts_by_months' do
    subject { super().amounts_by_months(bonuses) }

    let(:bonus_1) { { 'amount' => 100, 'date' => '2022-01-05' } }
    let(:bonus_2) { { 'amount' => -50, 'date' => '2022-01-10' } }
    let(:bonus_3) { { 'amount' => 200, 'date' => '2022-02-15' } }
    let(:bonus_4) { { 'amount' => 150, 'date' => '2022-02-25' } }

    context 'when bonuses contains only positive amounts' do
      let(:bonuses) { [bonus_1, bonus_3, bonus_4] }
      let(:expected_result) { { Date.new(2022, 1, 1) => 100, Date.new(2022, 2, 1) => 350 } }

      it 'sum all amounts and group it by months' do
        expect(subject).to eq(expected_result)
      end
    end

    context 'when bonuses contains negative amounts' do
      let(:bonuses) { [bonus_1, bonus_2, bonus_3, bonus_4] }
      let(:expected_result) { { Date.new(2022, 1, 1) => 100, Date.new(2022, 2, 1) => 350 } }

      it 'sum only positive amounts and group it by months' do
        expect(subject).to eq(expected_result)
      end
    end
  end
end
