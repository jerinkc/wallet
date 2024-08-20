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

      # { from: [:to] }
      PERMITTED_STATUS_CHANGES = {
        requested: [:approved, :rejected, :waiting_for_adjustment_acceptance],
        approved: [:open],
        rejected: [],
        waiting_for_adjustment_acceptance: [:open, :rejected, :readjustment_requested],
        readjustment_requested: [:approved, :rejected, :waiting_for_adjustment_acceptance],
        open: [:closed]
      }

      # who is responsible
      ACTOR = {
        approved: [:admin],
        rejected: [:admin, :borrower],
        waiting_for_adjustment_acceptance: [:admin],
        readjustment_requested: [:borrower],
        open: [:borrower],
        closed: [:borrower, :admin]
      }
    end
  end
end
