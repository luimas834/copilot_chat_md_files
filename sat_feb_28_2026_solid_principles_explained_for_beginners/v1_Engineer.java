package com.codurance.ocp;

public class Engineer extends Employee {

    Engineer(int salary) {
        super(salary);
    }

    @Override
    public int payAmount() {
        return salary;
    }
}