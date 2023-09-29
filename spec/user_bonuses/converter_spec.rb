describe UserBonuses::Converter, type: :service do
  subject { described_class }

  describe '#execute' do
    subject { super().execute(bonuses, type_id, page, limit) }

    let(:bonuses) { [double(:bonuses)] }
    let(:type_id) { double(:type_id) }
    let(:page) { double(:page) }
    let(:limit) { double(:limit) }

    context 'when Summator calls successfully' do
      let(:summator_result) { double(:summator_result) }

      before { allow(UserBonuses::Summator).to receive(:amounts_by_months).with(bonuses).and_return(summator_result) }

      context 'when Filter by_type calls successfully' do
        let(:filter_result) { double([:filter_result], count: 1) }

        before { allow(UserBonuses::Filter).to receive(:by_type).with(bonuses, type_id).and_return(filter_result) }

        context 'when Paginator calls successfully' do
          let(:paginator_result) { double(:paginator_result) }

          before do
            allow(UserBonuses::Paginator)
              .to receive(:execute)
              .with(filter_result, page, limit)
              .and_return(paginator_result)
          end

          context 'when Filter group_by_months calls successfully' do
            let(:group_by_result) { double(:group_by_result) }

            before do
              allow(UserBonuses::Filter).to receive(:group_by_months).with(paginator_result).and_return(group_by_result)
            end

            context 'when Modifier calls successfully' do
              let(:modified_result) { double(:modified_result) }
              let(:result) { { bonuses: modified_result, total_count: bonuses.count } }

              before do
                allow(UserBonuses::Modifier)
                  .to receive(:rework_batch)
                  .with(group_by_result, summator_result)
                  .and_return(modified_result)
              end

              it 'calls Summator amounts_by_months' do
                expect(UserBonuses::Summator).to receive(:amounts_by_months).with(bonuses)

                subject
              end

              it 'calls Filter by_type' do
                expect(UserBonuses::Filter).to receive(:by_type).with(bonuses, type_id)

                subject
              end

              it 'calls Paginator' do
                expect(UserBonuses::Paginator).to receive(:execute).with(filter_result, page, limit)

                subject
              end

              it 'calls Filter group_by_months' do
                expect(UserBonuses::Filter).to receive(:group_by_months).with(paginator_result)

                subject
              end

              it 'calls Modifier rework_batch' do
                expect(UserBonuses::Modifier).to receive(:rework_batch).with(group_by_result, summator_result)

                subject
              end

              it 'returns Result ok' do
                expect(subject).to be_instance_of(Result::Ok)
              end

              it 'returns Result with modified bonuses and total count' do
                expect(subject.data).to eq(result)
              end
            end

            context 'when Modifier call failed' do
              before { allow(UserBonuses::Modifier).to receive(:rework_batch).and_raise(StandardError) }

              it 'returns a Result::Error' do
                expect(subject).to be_instance_of(Result::Error)
              end
            end
          end

          context 'when Filter group_by_month call failed' do
            before { allow(UserBonuses::Filter).to receive(:group_by_months).and_raise(StandardError) }

            it 'returns a Result::Error' do
              expect(subject).to be_instance_of(Result::Error)
            end
          end
        end

        context 'when Paginator call failed' do
          before { allow(UserBonuses::Paginator).to receive(:execute).and_raise(StandardError) }

          it 'returns a Result::Error' do
            expect(subject).to be_instance_of(Result::Error)
          end
        end
      end

      context 'when Filter by_type call failed' do
        before { allow(UserBonuses::Filter).to receive(:by_type).and_raise(StandardError) }

        it 'returns a Result::Error' do
          expect(subject).to be_instance_of(Result::Error)
        end
      end
    end

    context 'when Summator call failed' do
      before { allow(UserBonuses::Summator).to receive(:amounts_by_months).and_raise(StandardError) }

      it 'returns a Result::Error' do
        expect(subject).to be_instance_of(Result::Error)
      end
    end
  end
end
