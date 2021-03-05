from datetime import datetime,date,timedelta
import pytest

class BankAccount ():
    def __init__(self, name = 'Rumbi Gwanz', id = '123', creation_date = date.today(), balance = 0):
        self.name = name 
        self.id = id
        self.creation_date = creation_date
        if creation_date > date.today():
            raise Exception ('Bank Account cant be created')
        self.balance = balance 
    
    def deposit (self, amount):
        self.balance += amount
        return self.balance 

    def withdrawl (self, amount):
        self.balance -= amount
        return self.balance

    def view_balance (self):
        return self.balance
    
    

class CheckingAccount (BankAccount):
    def withdrawl(self, amount):
        if self.balance >= amount:
            self.balance -= amount
        else:
            if self.balance <= amount:
                self.balance -= amount
                self.balance = self.balance - 30

    def deposit (self, amount):
        self.balance += amount
        return self.balance 

class SavingsAccount (BankAccount):
    def withdrawl(self, amount):
        if date.today() - self.creation_date < timedelta(days=180):
            print ('Withdrawals not allowed')
        else:
            if self.balance >= amount:
                self.balance -= amount
            else:
                self.balance <= amount
                print('Withdrawl not allowed')
                

@pytest.fixture 
def create_account_objects():
    SA = SavingsAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    CA = CheckingAccount('George','124', date.today() - timedelta(days=180), balance = 100)
    BAA = BankAccount ('George','124', date.today() - timedelta(days=180), balance = 100)
    return [SA, CA, BAA]


@pytest.mark.parametrize('a, expected', [((500,450)), ((450,400)), ((400,350)), ((350,300)), ((300,250)), ((250,200))])
def test_savings_update_parametrized(a, expected):
    SW = 50
    SA = SavingsAccount('George','124', date.today() - timedelta(days=181), balance = a)
    SA.withdrawl(SW)
    assert SA.balance == expected
    
    
    
        

@pytest.mark.parametrize('a, expected', [((500,450)), ((450,400)), ((400,350)), ((350,300)), ((300,250)), ((250,200))])
def test_checking_withdraw_parametrized(a, expected):
    CW = 50
    CA = CheckingAccount('George','124', date.today() - timedelta(days=181), balance = a)
    CA.withdrawl(CW)
    assert CA.balance == expected
    
    




def test_consturctor():
    with pytest.raises(Exception):
        BankAccount ('George','124', date.today() + timedelta(days=180), balance = 100)

def test_savings_update(create_account_objects):
    SW = 50
    # SA = SavingsAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    SA = create_account_objects[0]
    SA.withdrawl(SW)
    if SA.view_balance() == 50:
        assert True
    else:
        assert False
    
def test_savings_negative(create_account_objects):
    SW = 150
    SA = create_account_objects[0]
    # SA = SavingsAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    SA.withdrawl(SW)
    if SA.view_balance() == -150:
        assert False
    else:
        assert True

def test_savings_young_account(create_account_objects):
    SW = 50
    SA = create_account_objects[0]
    SA.creation_date = date.today() - timedelta(days=179)
    # SA = SavingsAccount('George','124', date.today() - timedelta(days=179), balance = 100)
    SA.withdrawl(SW)
    assert SA.balance == 100
    

@pytest.mark.xfail()
def test_checking_deposit(create_account_objects):
    CD = 50
    CA = create_account_objects[1]
    # CA = CheckingAccount('George','124', date.today() - timedelta(days=180), balance = 100)
    CA.withdrawl(CD)
    assert CA.view_balance() == 149

def test_checking_withdrawl(create_account_objects):
    CW = 50
    CA = create_account_objects[1]
    # CA = CheckingAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    CA.withdrawl(CW)
    if CA.view_balance() == 50:
        assert True
    else:
        assert False

def test_checking_overdraft(create_account_objects):
    CW = 150
    CA = create_account_objects[1]
    # CA = CheckingAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    CA.withdrawl(CW)
    assert CA.view_balance() == -80
      