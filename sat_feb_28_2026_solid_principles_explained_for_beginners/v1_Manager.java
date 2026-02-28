package com.codurance.ocp;

public class Manager extends Employee {

    private int bonus;

    Manager(int salary, int bonus) {
        super(salary);
        this.bonus = bonus;
    }

    @Override
    public int payAmount() {
        return salary + bonus;
    }
}