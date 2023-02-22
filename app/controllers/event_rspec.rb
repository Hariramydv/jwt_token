require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:events) { create_list(:event,2)}
  let(:status_cancelled) { create(:event, status: "cancelled")}
  let(:status_delete_setttled) { create(:event, status: "delete_settled")}
  let(:future) { create(:event, :future)}
  let(:past) { create(:event, :past)}

  it { should belong_to(:division) }
  it { should belong_to(:schedule) }
  it { should belong_to(:facility_detail) }
  it { should have_many(:event_payments) }
  it { should have_many(:event_requests) }
  it { should serialize(:occupied_subresources) }
  it { should belong_to(:product_name_of_resource_registration) }
  it { is_expected.to callback(:set_end_time).after(:create) }
  it { is_expected.to callback(:check_status).before(:destroy) }
  it {should define_enum_for(:status).with_values( draft_calendar: 0,unscheduled: 1, scheduled: 2, in_review: 3, settled: 4, cancelled: 5, delete_in_review: 6, delete_settled: 7 )}
  it {should define_enum_for(:bracket).with_values(winner: 0, loser: 1, finale: 2, aux_finale: 3)}
  
  describe ".scope" do
    before do
      events
      status_cancelled
      status_delete_setttled
      past
      future
    end
    it "active_events" do
      expect(described_class.active_events).not_to include(status_cancelled,status_delete_setttled)
    end
    it "feature" do
      expect(described_class.feature).to include(future)
    end
    it "past" do
      expect(described_class.past).not_to include(future, events)
    end
  end
end
