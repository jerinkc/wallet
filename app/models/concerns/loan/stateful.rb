module Loan
  module Stateful
    extend ActiveSupport::Concern

    included do
      enum status: {
        requested: 0,
        rejected: 1,
        approved: 2,
        open: 3,
        closed: 4,
        waiting_for_adjustment_acceptance: 5,
        readjustment_requested: 6
      }

      PERMITTED_STATUS_CHANGE = {
        reject: [:requested, :approved, :waiting_for_adjustment_acceptance],
        approved: [:requested],
        waiting_for_adjustment_acceptance: [:requested],
        open: [:approved, :waiting_for_adjustment_acceptance],
        closed: [:open],
        readjustment_requested: [:waiting_for_adjustment_acceptance]
      }
    end
  end
end
