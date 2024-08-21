admin = UserGenerator.new({email: 'admin@example.com', password: 'password', full_name: 'Admin', admin: true}).generate
user1 = UserGenerator.new({email: 'john@example.com', password: 'password', full_name: 'John' }).generate
user2 = UserGenerator.new({email: 'albert@example.com', password: 'password', full_name: 'Albert'}).generate



loan_account_params = { amount: 1000, interest_percentage: 5 }
user1_loan_account_service = LoanService.new(
                                              actor: user1,
                                              action: :create,
                                              account: LoanAccount.new(loan_account_params),
                                              params: loan_account_params
                                            )
user1_loan_account_service.call

user2_loan_account_service = LoanService.new(
                                              actor: user2,
                                              action: :create,
                                              account: LoanAccount.new(loan_account_params),
                                              params: loan_account_params
                                            )
user2_loan_account_service.call


user1_loan_account = user1_loan_account_service.account
user2_loan_account = user2_loan_account_service.account

admin_loan_account_service = LoanService.new(
                                              actor: Admin.record,
                                              action: :approve,
                                              account: user1_loan_account_service.account
                                            )
admin_loan_account_service.call
