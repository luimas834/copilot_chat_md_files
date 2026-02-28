package com.codurance.isp;

public class Dog implements Animal {
    @Override
    public void fly() {
        // EMPTY! Dogs can't fly, but forced to implement this method!
    }

    @Override
    public void run() {
        System.out.print("Dog is running");
    }

    @Override
    public void bark() {
        System.out.print("Dog is barking");
    }
}