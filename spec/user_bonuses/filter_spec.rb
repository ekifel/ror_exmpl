describe UserBonuses::Filter, type: :service do
  subject { described_class }

  describe '#by_type' do
    subject { super().by_type(bonuses, type_id) }

    let(:bonuses) { [positive_bonus, negative_bonus] }
    let(:positive_bonus) { { 'amount' => 100 } }
    let(:negative_bonus) { { 'amount' => -100 } }

    context 'when type_id is 1' do
      let(:type_id) { 1 }

      it 'returns bonuses with positive amount only' do
        expect(subject).to eq([positive_bonus])
      end
    end

    context 'when type_id is 2' do
      let(:type_id) { 2 }

      it 'returns bonuses with negative amount only' do
        expect(subject).to eq([negative_bonus])
      end
    end

    context 'when type_id is zero' do
      let(:type_id) { 0 }

      it 'returns all bonuses' do
        expect(subject).to eq(bonuses)
      end
    end
  end

  describe '#group_by_months' do
    subject { super().group_by_months(bonuses) }

    let(:bonuses) do
      [
        { 'date' => '2022-01-01' },
        { 'date' => '2022-02-01' },
        { 'date' => '2022-03-01' },
        { 'date' => '2022-03-15' }
      ]
    end

    let(:expected_result) do
      {
        Date.new(2022, 1, 1) => [{ 'date' => '2022-01-01' }],
        Date.new(2022, 2, 1) => [{ 'date' => '2022-02-01' }],
        Date.new(2022, 3, 1) => [{ 'date' => '2022-03-01' }, { 'date' => '2022-03-15' }]
      }
    end

    it 'groups bonuses by months' do
      expect(subject).to eq(expected_result)
    end
  end
end
