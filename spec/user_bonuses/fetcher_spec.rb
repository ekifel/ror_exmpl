describe UserBonuses::Fetcher, type: :service do
  subject { described_class }

  describe '#execute' do
    subject { super().execute(account_id: account_id, type_id: type_id, page: page, limit: limit) }

    let(:account_id) { double(:account_id) }
    let(:type_id) { double(:type_id) }
    let(:page) { double(:page) }
    let(:limit) { double(:limit) }

    before { allow(BonusService::Loyal).to receive(:fetch_bonuses).with(account_id: account_id).and_return(fetch_result) }

    context 'when fetching from bonus service was successfully' do
      let(:fetch_result) { Result.ok(data: { bonuses: bonuses }) }
      let(:bonuses) { [double(:bonuses)] }

      context 'when bonuses was converted successfully' do
        let(:converter_result) { Result.ok(data: { bonuses: bonuses, total_count: bonuses.count }) }
        let(:expected_result_data) { { bonuses: bonuses, total_count: bonuses.count } }

        before do
          allow(UserBonuses::Converter)
            .to receive(:execute)
            .with(fetch_result.data[:bonuses], type_id, page, limit)
            .and_return(converter_result)
        end

        it 'returns Result ok' do
          expect(subject).to be_instance_of(Result::Ok)
        end

        it 'returns bonuses and total_count in result data' do
          expect(subject.data).to eq(expected_result_data)
        end
      end

      context 'when bonuses convert failed' do
        before { allow(UserBonuses::Converter).to receive(:execute).and_raise(StandardError) }

        it 'return Result error' do
          expect(subject).to be_instance_of(Result::Error)
        end

        it 'return error with 500 code' do
          expect(subject.http_code).to eq(500)
        end
      end
    end

    context 'when fetching from bonus service failed' do
      let(:fetch_result) { Result.error }

      it 'returns result error' do
        expect(subject).to eq(fetch_result)
      end
    end
  end
end
