describe UserBonuses::Modifier, type: :service do
  subject { described_class }

  describe '#rework_batch' do
    subject { super().rework_batch(bonuses, amounts) }

    let(:bonuses) do
      {
        Date.parse('2022-01-01') => [
          {
            'id' => 1,
            'uid' => '1',
            'amount' => 10.0,
            'date' => '2022-01-01',
            'source_id' => '1',
            'cash_id' => '1',
            'store' => '1',
            'store_name' => 'Store 1',
            'source' => 'Source 1',
            'chequesum' => '1',
            'balance' => 0.0,
            'commentary' => 'Comment 1'
          }
        ],
        Date.parse('2022-02-01') => [
          {
            'id' => 2,
            'uid' => '2',
            'amount' => 11.1,
            'date' => '2022-02-01',
            'source_id' => '2',
            'cash_id' => '2',
            'store' => '2',
            'store_name' => 'Store 2',
            'source' => 'Source 2',
            'chequesum' => '2',
            'balance' => 0.0,
            'commentary' => 'Comment 2'
          }
        ]
      }
    end

    let(:amounts) do
      {
        Date.parse('2022-01-01') => 10.0,
        Date.parse('2022-02-01') => 11.1
      }
    end

    let(:expected_result) do
      [
        {
          month: DateTime.parse('2022-01-01').to_i,
          amount: '10.0',
          data: [
            {
              cash_id: '1',
              shop_id: '1',
              purchase_id: 1,
              date: DateTime.parse('2022-01-01').to_i,
              shop_address: 'Address 1',
              check_number: '1.1',
              bonus: '10.0',
              is_authorization_bonus: false,
              is_referral_bonus: false,
              receipt_id: '1'
            }.as_json
          ]
        },
        {
          month: DateTime.parse('2022-02-01').to_i,
          amount: '11.1',
          data: [
            {
              cash_id: '2',
              shop_id: '2',
              purchase_id: 2,
              date: DateTime.parse('2022-02-01').to_i,
              shop_address: 'Address 2',
              check_number: '2.2',
              bonus: '11.1',
              is_authorization_bonus: false,
              is_referral_bonus: false,
              receipt_id: '2'
            }.as_json
          ]
        }
      ]
    end

    before do
      allow(Shop).to receive(:find_by).with(store_id: '1').and_return(double(address: 'Address 1'))
      allow(Shop).to receive(:find_by).with(store_id: '2').and_return(double(address: 'Address 2'))
    end

    it 'returns bonuses grouped by month with modified fields' do
      expect(subject).to eq(expected_result)
    end
  end
end
