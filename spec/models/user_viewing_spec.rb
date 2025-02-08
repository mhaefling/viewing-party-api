require "rails_helper"

RSpec.describe UserViewing, type: :model do
  describe "validations" do
    it { should belong_to :user }
    it { should belong_to :viewing_party }
  end
end