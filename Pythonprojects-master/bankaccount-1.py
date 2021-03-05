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
                



def test_consturctor():
    with pytest.raises(Exception):
        BankAccount ('George','124', date.today() + timedelta(days=180), balance = 100)

def test_savings_update():
    SW = 50
    SA = SavingsAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    SA.withdrawl(SW)
    if SA.view_balance() == 50:
        assert True
    else:
        assert False
    
def test_savings_negative():
    SW = 150
    SA = SavingsAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    SA.withdrawl(SW)
    if SA.view_balance() == -150:
        assert False
    else:
        assert True

def test_savings_young_account():
    SW = 50
    SA = SavingsAccount('George','124', date.today() - timedelta(days=179), balance = 100)
    SA.withdrawl(SW)
    if SA.view_balance() == 50:
        assert False
    else:
        assert True

@pytest.mark.xfail()
def test_checking_deposit():
    CD = 50
    CA = CheckingAccount('George','124', date.today() - timedelta(days=180), balance = 100)
    CA.withdrawl(CD)
    assert CA.view_balance() == 149

def test_checking_withdrawl():
    CW = 50
    CA = CheckingAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    CA.withdrawl(CW)
    if CA.view_balance() == 50:
        assert True
    else:
        assert False

def test_checking_overdraft():
    CW = 150
    CA = CheckingAccount('George','124', date.today() - timedelta(days=181), balance = 100)
    CA.withdrawl(CW)
    assert CA.view_balance() == -80
      
    

    






    

