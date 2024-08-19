class Admin
  attr_reader :record

  def self.record
    @record ||= User.find_sole_by(admin: true)
  end

  def self.wallet
    record.wallet_account
  end
end
