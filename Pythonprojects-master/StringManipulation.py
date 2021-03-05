
def double_char(str):
  sts = ''
  for i in str:
    sts += i*2
  return sts
    
  
def count_hi(str):
  total = 0
  for i in range(len(str)):
    if str[i:i+2] == 'hi':
      total += 1
  return total

def cat_dog(str):
  totalcat = 0 
  for i in range(len(str)):
    if str[i:i+3] == 'cat':
      totalcat = totalcat +1
  
  totaldog = 0
  for i in range(len(str)):
    if str[i:i+3] == 'dog':
      totaldog = totaldog +1
      
  if totalcat == totaldog:
    return True
  else:
    return False
  
def count_code(str):
  total = 0
  for i in range(len(str)):
    a = str[i:i+4]
    if a[0:2] == 'co':
      if a[3:4] == 'e':
        total = total + 1
  return total

def end_other(a, b):
  c = a.lower()
  d = b.lower()
  if c.endswith(d) or d.endswith(c):
    return True
  return False
  
def xyz_there(str):
  for i in range(len(str)):
    if str[i:i+3] == 'xyz':
      if str[i-1] != '.':
        return True
  return False
 
def count_evens(nums):
  total = 0
  for x in nums:
    if x % 2 == 0:
      total += 1
  return total

def sum13(nums):
  total  = 0
  for i in range(len(nums)):
    x = nums[i]
    if nums[i-1] == 13 and i !=0:
      total = total + 0
    elif x == 13:
      total = total + 0
    else:
      total = total + x
  return total

def big_diff(nums):
  nums.sort()
  return nums[-1] - nums[0]

def centered_average(nums):
  nums.sort()
  return sum(nums[1:-1])/len(nums[1:-1])

def has22(nums):
  for i in range(len(nums) - 1):
    if nums[i] == 2 and nums[i + 1] == 2:
      return True
  return False
