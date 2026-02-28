package com.codurance.srp;

public class AccountService {

    private TransactionRepository transactionRepository;
    private Clock clock;
    private StatementPrinter statementPrinter;

    public AccountService(TransactionRepository transactionRepository, Clock clock, StatementPrinter statementPrinter) {
        this.transactionRepository = transactionRepository;
        this.clock = clock;
        this.statementPrinter = statementPrinter;
    }

    public void deposit(int amount) {
        transactionRepository.add(transactionWith(amount));
    }

    public void withdraw(int amount) {
        transactionRepository.add(transactionWith(-amount));
    }

    public void printStatement() {
        statementPrinter.print(transactionRepository.all());
    }

    private Transaction transactionWith(int amount) {
        return new Transaction(clock.today(), amount);
    }
}