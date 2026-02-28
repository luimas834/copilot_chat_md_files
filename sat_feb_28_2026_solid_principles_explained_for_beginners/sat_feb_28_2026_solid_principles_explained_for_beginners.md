# Copilot Chat Conversation Export: SOLID principles explained for beginners

**User:** @luimas834
**Thread URL:** https://github.com/copilot/c/f550cb18-4e43-4fe1-a398-7da6f8cd1e03

## @luimas834

solve it and explain me the solve in very very details....like i am learning from the very basic 

## Copilot



I'd love to help you learn about SOLID principles by exploring this repository! Let me first look at the repository structure and understand what exercises are available.Let me explore the repository structure and understand all the SOLID kata exercises first.Now let me explore each directory and the README:Now let me get all the Java source files from each module:Now let me get all the Java files for the remaining 4 modules:Now let me get the test files for the remaining exercises:Now I have all the code. Let me give you a comprehensive, beginner-friendly explanation of every kata in this repository.

---

# 🏛️ SOLID Principles Kata — Complete Beginner's Guide

This repo contains **5 exercises** — one for each letter of **SOLID**. Each exercise has code that **violates** a SOLID principle. Your job is to **refactor** (rewrite/improve) the code so it no longer violates the principle.

Let me walk you through **every single exercise**: what the problem is, why it's bad, and exactly how to fix it.

---

## 📖 First: What is SOLID?

SOLID is an acronym — 5 rules that help you write code that is:
- **Easy to change** later
- **Easy to understand**
- **Less buggy**

| Letter | Principle | One-Sentence Meaning |
|--------|-----------|---------------------|
| **S** | Single Responsibility | A class should do **only one thing** |
| **O** | Open/Closed | You should add new features **without changing** existing code |
| **L** | Liskov Substitution | Child classes should work **anywhere** the parent class works |
| **I** | Interface Segregation | Don't force a class to implement methods it **doesn't need** |
| **D** | Dependency Inversion | Depend on **abstractions** (interfaces), not concrete classes |

---

## 1️⃣ SRP — Single Responsibility Principle

### 📁 The Problem Code

```java name=AccountService.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/srp/src/main/java/com/codurance/srp/AccountService.java
package com.codurance.srp;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.MessageFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicInteger;

import static java.util.stream.Collectors.toCollection;

public class AccountService {

    private static final String STATEMENT_HEADER = "DATE | AMOUNT | BALANCE";
    private static final String DATE_FORMAT = "dd/MM/yyyy";
    private static final String AMOUNT_FORMAT = "#.00";

    private TransactionRepository transactionRepository;
    private Clock clock;
    private Console console;

    public AccountService(TransactionRepository transactionRepository, Clock clock, Console console) {
        this.transactionRepository = transactionRepository;
        this.clock = clock;
        this.console = console;
    }

    public void deposit(int amount) {
        transactionRepository.add(transactionWith(amount));
    }

    public void withdraw(int amount) {
        transactionRepository.add(transactionWith(-amount));
    }

    public void printStatement() {
        printHeader();
        printTransactions();
    }

    private void printHeader() {
        printLine(STATEMENT_HEADER);
    }

    private void printTransactions() {
        List<Transaction> transactions = transactionRepository.all();
        final AtomicInteger balance = new AtomicInteger(0);
        transactions.stream()
                .map(transaction -> statementLine(transaction, balance.addAndGet(transaction.amount())))
                .collect(toCollection(LinkedList::new))
                .descendingIterator()
                .forEachRemaining(this::printLine);
    }

    private Transaction transactionWith(int amount) {
        return new Transaction(clock.today(), amount);
    }

    private String statementLine(Transaction transaction, int balance) {
        return MessageFormat.format("{0} | {1} | {2}", formatDate(transaction.date()), formatNumber(transaction.amount()), formatNumber(balance));
    }

    private String formatDate(LocalDate date) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(DATE_FORMAT);
        return dateFormatter.format(date);
    }

    private String formatNumber(int amount) {
        DecimalFormat decimalFormat = new DecimalFormat(AMOUNT_FORMAT, DecimalFormatSymbols.getInstance(Locale.UK));
        return decimalFormat.format(amount);
    }

    private void printLine(String line) {
        console.printLine(line);
    }
}
```

### 🔍 What's Wrong? (Explained Like You're a Beginner)

Imagine you're a cook at a restaurant. The SRP says: **"Each cook should have ONE job."** One cook chops vegetables. Another cook grills meat. Another cook plates the food.

But in this code, `AccountService` is doing **THREE different jobs**:

1. **Banking logic** — depositing and withdrawing money
2. **Formatting logic** — turning transactions into strings with dates and numbers formatted nicely (`formatDate`, `formatNumber`, `statementLine`)
3. **Printing logic** — printing the statement to the console (`printStatement`, `printHeader`, `printTransactions`)

**Why is this bad?** If you want to change how dates are formatted, you have to modify `AccountService`. If you want to print to a file instead of the console, you have to modify `AccountService`. Every change to ANY of these 3 jobs means touching this ONE class. This makes it fragile and hard to maintain.

### ✅ The Solution: Split Into Separate Classes

We create a new class called `StatementPrinter` that handles ONLY the formatting and printing responsibility:

```java name=StatementPrinter.java
package com.codurance.srp;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.MessageFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicInteger;

import static java.util.stream.Collectors.toCollection;

public class StatementPrinter {

    private static final String STATEMENT_HEADER = "DATE | AMOUNT | BALANCE";
    private static final String DATE_FORMAT = "dd/MM/yyyy";
    private static final String AMOUNT_FORMAT = "#.00";

    private Console console;

    public StatementPrinter(Console console) {
        this.console = console;
    }

    public void print(List<Transaction> transactions) {
        printHeader();
        printTransactions(transactions);
    }

    private void printHeader() {
        console.printLine(STATEMENT_HEADER);
    }

    private void printTransactions(List<Transaction> transactions) {
        final AtomicInteger balance = new AtomicInteger(0);
        transactions.stream()
                .map(transaction -> statementLine(transaction, balance.addAndGet(transaction.amount())))
                .collect(toCollection(LinkedList::new))
                .descendingIterator()
                .forEachRemaining(console::printLine);
    }

    private String statementLine(Transaction transaction, int balance) {
        return MessageFormat.format("{0} | {1} | {2}",
                formatDate(transaction.date()),
                formatNumber(transaction.amount()),
                formatNumber(balance));
    }

    private String formatDate(LocalDate date) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(DATE_FORMAT);
        return dateFormatter.format(date);
    }

    private String formatNumber(int amount) {
        DecimalFormat decimalFormat = new DecimalFormat(AMOUNT_FORMAT, DecimalFormatSymbols.getInstance(Locale.UK));
        return decimalFormat.format(amount);
    }
}
```

And now `AccountService` becomes clean and focused on ONLY banking logic:

```java name=AccountService.java
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
```

### 🎯 What Changed and Why

| Before | After |
|--------|-------|
| `AccountService` = 85 lines doing 3 jobs | `AccountService` = ~30 lines doing 1 job (banking) |
| Formatting code mixed with banking code | `StatementPrinter` = a separate class for formatting/printing |
| Changing date format requires editing the banking class | Changing date format only touches `StatementPrinter` |

**Think of it this way:** Now the cook who grills meat (AccountService) doesn't also have to plate the food (StatementPrinter). Each class has **one reason to change**.

---

## 2️⃣ OCP — Open/Closed Principle

### 📁 The Problem Code

```java name=Employee.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/ocp/src/main/java/com/codurance/ocp/Employee.java
package com.codurance.ocp;

public class Employee {

    private int salary;
    private int bonus;
    private EmployeeType type;

    Employee(int salary, int bonus, EmployeeType type) {
        this.salary = salary;
        this.bonus = bonus;
        this.type = type;
    }

    public int payAmount() {
        switch (this.type) {
            case ENGINEER:
                return salary;
            case MANAGER:
                return salary + bonus;
            default:
                return 0;
        }
    }
}
```

```java name=EmployeeType.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/ocp/src/main/java/com/codurance/ocp/EmployeeType.java
package com.codurance.ocp;

public enum EmployeeType {
    MANAGER, ENGINEER
}
```

### 🔍 What's Wrong? (Explained Like You're a Beginner)

Imagine you have a vending machine. Right now it sells Coke and Pepsi. The OCP says: **"When you want to add Fanta, you should add a NEW slot — NOT open up the machine and rewire everything."**

Look at the `payAmount()` method. It uses a `switch` statement:
- If `ENGINEER` → return salary
- If `MANAGER` → return salary + bonus

**What happens when you add a new type, like `INTERN` or `DIRECTOR`?** You have to:
1. Open `EmployeeType` and add the new type
2. Open `Employee` and **modify** the `switch` statement

You're **modifying existing code** every time you add a new type. That's the violation! The class should be **open for extension** (you can add new types) but **closed for modification** (you don't change the existing class).

### ✅ The Solution: Use Polymorphism (Subclasses)

Instead of one `Employee` class with a switch, create a **base class** and let each type define its own `payAmount()`:

```java name=Employee.java
package com.codurance.ocp;

public abstract class Employee {

    protected int salary;

    Employee(int salary) {
        this.salary = salary;
    }

    public abstract int payAmount();
}
```

```java name=Engineer.java
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
```

```java name=Manager.java
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
```

### 🎯 What Changed and Why

| Before | After |
|--------|-------|
| ONE class with a `switch` that you must edit for every new type | Each type is its OWN class |
| Adding `INTERN` = modify `Employee` + modify `EmployeeType` | Adding `Intern` = just create a NEW `Intern.java` file |
| Existing code gets changed (risky!) | Existing code is NEVER touched (safe!) |

**Think of it this way:** Now when you want to add a "Director" employee type, you just create `Director.java` that extends `Employee`. You never touch `Engineer` or `Manager`. **Open for extension, closed for modification!**

---

## 3️⃣ LSP — Liskov Substitution Principle

### 📁 The Problem Code

```java name=Vehicle.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/lsp/src/main/java/com/codurance/lsp/Vehicle.java
package com.codurance.lsp;

public abstract class Vehicle {

    private boolean engineStarted = false;

    public void startEngine() {
        this.engineStarted = true;
    }

    public boolean engineIsStarted() {
        return engineStarted;
    }

    public void stopEngine() {
        this.engineStarted = false;
    }

    public abstract void fillUpWithFuel();

    public abstract void chargeBattery();
}
```

```java name=PetrolCar.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/lsp/src/main/java/com/codurance/lsp/PetrolCar.java
package com.codurance.lsp;

public class PetrolCar extends Vehicle {
  private static final int FUEL_TANK_FULL = 100;
  private int fuelTankLevel = 0;

  @Override
  public void fillUpWithFuel() {
    this.fuelTankLevel = FUEL_TANK_FULL;
  }

  @Override
  public void chargeBattery() {
    throw new UnsupportedOperationException("A petrol car cannot be recharged");
  }

  public int fuelTankLevel() {
    return fuelTankLevel;
  }
}
```

```java name=ElectricCar.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/lsp/src/main/java/com/codurance/lsp/ElectricCar.java
package com.codurance.lsp;

public class ElectricCar extends Vehicle{

    private static final int BATTERY_FULL = 100;
    private int batteryLevel;

    @Override
    public void fillUpWithFuel() {
        throw new UnsupportedOperationException("It's an electric car");
    }

    @Override
    public void chargeBattery() {
        batteryLevel = BATTERY_FULL;
    }

    public int batteryLevel() {
        return batteryLevel;
    }
}
```

```java name=FillingStation.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/lsp/src/main/java/com/codurance/lsp/FillingStation.java
package com.codurance.lsp;

public class FillingStation {

    public void refuel(Vehicle vehicle) {
        if (vehicle instanceof PetrolCar) {
            vehicle.fillUpWithFuel();
        }
    }

    public void charge(Vehicle vehicle) {
        if (vehicle instanceof ElectricCar) {
            vehicle.chargeBattery();
        }
    }
}
```

### 🔍 What's Wrong? (Explained Like You're a Beginner)

Imagine you have a box labeled "Fruits." The LSP says: **"Anything inside a box labeled 'Fruits' should behave like a fruit — you should be able to eat it."** If you put a plastic toy fruit in there, someone will try to eat it and break their teeth. That's a violation!

Here's what's happening:
- `Vehicle` says: "All vehicles can `fillUpWithFuel()` AND `chargeBattery()`"
- But a `PetrolCar` **throws an exception** when you try to `chargeBattery()` — it CANNOT do this!
- And an `ElectricCar` **throws an exception** when you try to `fillUpWithFuel()` — it CANNOT do this!

So if someone writes code like `vehicle.fillUpWithFuel()` (where `vehicle` is of type `Vehicle`), it might **blow up at runtime** if that vehicle happens to be an `ElectricCar`. The child class doesn't behave the way the parent class promised!

Also look at `FillingStation` — it uses `instanceof` checks, which is a **huge red flag** 🚩. It means the code doesn't trust that the child classes behave correctly.

### ✅ The Solution: Separate Hierarchies

Split `Vehicle` into two proper interfaces that represent what each type can ACTUALLY do:

```java name=Vehicle.java
package com.codurance.lsp;

public abstract class Vehicle {

    private boolean engineStarted = false;

    public void startEngine() {
        this.engineStarted = true;
    }

    public boolean engineIsStarted() {
        return engineStarted;
    }

    public void stopEngine() {
        this.engineStarted = false;
    }
}
```

```java name=FuelVehicle.java
package com.codurance.lsp;

public abstract class FuelVehicle extends Vehicle {
    public abstract void fillUpWithFuel();
}
```

```java name=ElectricVehicle.java
package com.codurance.lsp;

public abstract class ElectricVehicle extends Vehicle {
    public abstract void chargeBattery();
}
```

```java name=PetrolCar.java
package com.codurance.lsp;

public class PetrolCar extends FuelVehicle {
    private static final int FUEL_TANK_FULL = 100;
    private int fuelTankLevel = 0;

    @Override
    public void fillUpWithFuel() {
        this.fuelTankLevel = FUEL_TANK_FULL;
    }

    public int fuelTankLevel() {
        return fuelTankLevel;
    }
}
```

```java name=ElectricCar.java
package com.codurance.lsp;

public class ElectricCar extends ElectricVehicle {

    private static final int BATTERY_FULL = 100;
    private int batteryLevel;

    @Override
    public void chargeBattery() {
        batteryLevel = BATTERY_FULL;
    }

    public int batteryLevel() {
        return batteryLevel;
    }
}
```

```java name=FillingStation.java
package com.codurance.lsp;

public class FillingStation {

    public void refuel(FuelVehicle vehicle) {
        vehicle.fillUpWithFuel();
    }

    public void charge(ElectricVehicle vehicle) {
        vehicle.chargeBattery();
    }
}
```

### 🎯 What Changed and Why

| Before | After |
|--------|-------|
| `PetrolCar` has `chargeBattery()` that throws exception | `PetrolCar` doesn't even HAVE `chargeBattery()` |
| `ElectricCar` has `fillUpWithFuel()` that throws exception | `ElectricCar` doesn't even HAVE `fillUpWithFuel()` |
| `FillingStation` uses `instanceof` checks (code smell!) | `FillingStation` accepts the RIGHT type — no checks needed |
| Calling `vehicle.fillUpWithFuel()` might crash | Calling `fuelVehicle.fillUpWithFuel()` is always safe |

**Think of it this way:** Before, we promised "ALL vehicles can refuel AND charge." That was a lie. Now we say "FuelVehicles can refuel" and "ElectricVehicles can charge." No more lies, no more surprises!

---

## 4️⃣ ISP — Interface Segregation Principle

### 📁 The Problem Code

```java name=Animal.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/isp/src/main/java/com/codurance/isp/Animal.java
package com.codurance.isp;

public interface Animal {
    void fly();
    void run();
    void bark();
}
```

```java name=Dog.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/isp/src/main/java/com/codurance/isp/Dog.java
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
```

```java name=Bird.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/isp/src/main/java/com/codurance/isp/Bird.java
package com.codurance.isp;

public class Bird implements Animal {
    public void bark() { }  // EMPTY! Birds don't bark, but forced to implement!
    public void run() {
        System.out.print("Bird is running");
    }
    public void fly() {
        System.out.print("Bird is flying");
    }
}
```

### 🔍 What's Wrong? (Explained Like You're a Beginner)

Imagine you sign up for a gym membership. The ISP says: **"You should only pay for the services you actually use."** But this gym forces you to pay for swimming, tennis, yoga, AND rock climbing even if you only want the treadmill!

Look at the `Animal` interface. It forces EVERY animal to implement THREE methods:
- `fly()` — But **dogs can't fly!** So `Dog.fly()` is empty. It does nothing.
- `bark()` — But **birds don't bark!** So `Bird.bark()` is empty. It does nothing.

These empty methods are a big problem:
- They're confusing — someone might call `dog.fly()` expecting something to happen
- They're wasteful — you're writing code that does nothing
- They violate the principle: **"Don't force classes to depend on methods they don't use"**

### ✅ The Solution: Break Into Smaller Interfaces

Instead of ONE fat interface, create multiple small, specific interfaces:

```java name=Runnable.java
package com.codurance.isp;

public interface Runnable {
    void run();
}
```

```java name=Flyable.java
package com.codurance.isp;

public interface Flyable {
    void fly();
}
```

```java name=Barkable.java
package com.codurance.isp;

public interface Barkable {
    void bark();
}
```

Now each animal implements ONLY the interfaces that make sense for it:

```java name=Dog.java
package com.codurance.isp;

public class Dog implements Runnable, Barkable {

    @Override
    public void run() {
        System.out.print("Dog is running");
    }

    @Override
    public void bark() {
        System.out.print("Dog is barking");
    }
}
```

```java name=Bird.java
package com.codurance.isp;

public class Bird implements Runnable, Flyable {

    @Override
    public void run() {
        System.out.print("Bird is running");
    }

    @Override
    public void fly() {
        System.out.print("Bird is flying");
    }
}
```

### 🎯 What Changed and Why

| Before | After |
|--------|-------|
| ONE big `Animal` interface with 3 methods | THREE small interfaces: `Runnable`, `Flyable`, `Barkable` |
| `Dog` forced to implement `fly()` (empty body) | `Dog` only implements `Runnable` + `Barkable` (no `fly()`!) |
| `Bird` forced to implement `bark()` (empty body) | `Bird` only implements `Runnable` + `Flyable` (no `bark()`!) |
| Empty/dummy method implementations | No wasted code at all |

**Think of it this way:** Instead of one giant contract that says "every animal must fly, run, AND bark," we have smaller contracts. A Dog signs the "I can run" and "I can bark" contracts. A Bird signs the "I can run" and "I can fly" contracts. Nobody is forced to sign a contract for something they can't do!

---

## 5️⃣ DIP — Dependency Inversion Principle

### 📁 The Problem Code

```java name=BirthdayGreeter.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/dip/src/main/java/com/codurance/dip/BirthdayGreeter.java
package com.codurance.dip;

import java.time.MonthDay;

public class BirthdayGreeter {
    private final EmployeeRepository employeeRepository;
    private final Clock clock;

    public BirthdayGreeter(EmployeeRepository employeeRepository, Clock clock) {
        this.employeeRepository = employeeRepository;
        this.clock = clock;
    }

    public void sendGreetings() {
        MonthDay today = clock.monthDay();
        employeeRepository.findEmployeesBornOn(today)
                .stream()
                .map(employee -> emailFor(employee))
                .forEach(email -> new EmailSender().send(email));  // ⚠️ PROBLEM IS HERE!
    }

    private Email emailFor(Employee employee) {
        String message = String.format("Happy birthday, dear %s!", employee.getFirstName());
        return new Email(employee.getEmail(), "Happy birthday!", message);
    }
}
```

```java name=EmailSender.java url=https://github.com/jahs-es/solid-kata/blob/567a1a17573d0fad6d983c3f77af5b02c67c2212/dip/src/main/java/com/codurance/dip/EmailSender.java
package com.codurance.dip;

public class EmailSender {
    public void send(Email email) {
        System.out.print("To:"+email.getTo()+", Subject: "+email.getSubject()+", Message: "+email.getMessage());
    }
}
```

### 🔍 What's Wrong? (Explained Like You're a Beginner)

Imagine you want to charge your phone. The DIP says: **"Your phone should use a standard charging port (USB-C) — not a wire soldered directly to one specific wall outlet."** If the wire is soldered in, you can ONLY charge at that one outlet!

Look at `sendGreetings()` — this line is the problem:
```java
.forEach(email -> new EmailSender().send(email));
```

`BirthdayGreeter` is **creating** `new EmailSender()` directly inside its method! This means:
- `BirthdayGreeter` is **hardcoded** to use `EmailSender` — it's "soldered to the wall"
- You **cannot** test `BirthdayGreeter` without actually sending emails (or printing to console)
- If you want to send SMS instead of email, you have to **modify** `BirthdayGreeter`
- You **cannot** swap in a fake/mock email sender for testing

Notice how `EmployeeRepository` and `Clock` are already done correctly — they're injected through the constructor! But `EmailSender` is created inside the method.

### ✅ The Solution: Inject the Dependency Through an Interface

First, create an interface (an abstraction) for sending messages:

```java name=MessageSender.java
package com.codurance.dip;

public interface MessageSender {
    void send(Email email);
}
```

Make `EmailSender` implement this interface:

```java name=EmailSender.java
package com.codurance.dip;

public class EmailSender implements MessageSender {
    @Override
    public void send(Email email) {
        System.out.print("To:"+email.getTo()+", Subject: "+email.getSubject()+", Message: "+email.getMessage());
    }
}
```

Now inject the interface into `BirthdayGreeter` through the constructor:

```java name=BirthdayGreeter.java
package com.codurance.dip;

import java.time.MonthDay;

public class BirthdayGreeter {
    private final EmployeeRepository employeeRepository;
    private final Clock clock;
    private final MessageSender messageSender;  // Depends on INTERFACE, not concrete class!

    public BirthdayGreeter(EmployeeRepository employeeRepository, Clock clock, MessageSender messageSender) {
        this.employeeRepository = employeeRepository;
        this.clock = clock;
        this.messageSender = messageSender;
    }

    public void sendGreetings() {
        MonthDay today = clock.monthDay();
        employeeRepository.findEmployeesBornOn(today)
                .stream()
                .map(employee -> emailFor(employee))
                .forEach(email -> messageSender.send(email));  // ✅ Uses the injected abstraction!
    }

    private Email emailFor(Employee employee) {
        String message = String.format("Happy birthday, dear %s!", employee.getFirstName());
        return new Email(employee.getEmail(), "Happy birthday!", message);
    }
}
```

### 🎯 What Changed and Why

| Before | After |
|--------|-------|
| `new EmailSender()` created INSIDE the method | `MessageSender` injected through the constructor |
| Depends on **concrete** `EmailSender` class | Depends on **abstract** `MessageSender` interface |
| Can't test without printing to console | Can inject a mock `MessageSender` for testing |
| Want SMS? Must MODIFY `BirthdayGreeter` | Want SMS? Just create `SmsSender implements MessageSender` |

**Think of it this way:** Before, the phone charger was soldered to one wall outlet (EmailSender). Now the phone has a USB-C port (MessageSender interface), and you can plug in ANY compatible charger (EmailSender, SmsSender, SlackSender, etc.) without changing the phone!

---

## 🧩 Summary: The Big Picture

| # | Principle | Problem in the Repo | Solution |
|---|-----------|---------------------|----------|
| **S** | Single Responsibility | `AccountService` does banking + formatting + printing | Extract `StatementPrinter` class |
| **O** | Open/Closed | `switch` on employee type — must modify to add types | Use abstract class + subclasses (polymorphism) |
| **L** | Liskov Substitution | `PetrolCar.chargeBattery()` throws exception | Split `Vehicle` into `FuelVehicle` + `ElectricVehicle` |
| **I** | Interface Segregation | `Dog` forced to implement `fly()` | Split `Animal` into `Runnable`, `Flyable`, `Barkable` |
| **D** | Dependency Inversion | `new EmailSender()` hardcoded inside method | Create `MessageSender` interface + inject it |

Each solution follows the same pattern: **make your code flexible, testable, and safe to extend** by using abstractions (interfaces/abstract classes), separation of concerns, and dependency injection. These aren't just academic rules — they're practical tools that save you hours of debugging and rewriting in real projects! 🚀
