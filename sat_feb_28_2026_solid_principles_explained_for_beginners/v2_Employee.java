package com.codurance.ocp;

public abstract class Employee {

    protected int salary;

    Employee(int salary) {
        this.salary = salary;
    }

    public abstract int payAmount();
}