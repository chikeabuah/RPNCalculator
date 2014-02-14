=begin

	Author: Chike T. Abuah, Grinnell College '14
	File: rpn.rb
  Description: A Reverse Polish Notation Calculator
	Date: Created on 1/21/2014
  Last Modified: On 2/11/2014
	Version: Ruby 1.9.3

  Assumptions/Preconditions:
    This program relies on the following to exhibit correct behaviour:
      -The entire input must be enclosed in quotation marks because we
        will only evaluate the first argument passed to our script in the
        command-line.
      -The four basic arithmetic operations are usable (+,-,*,/), as well as
        the square root operation.
      -Each operator will accept exactly two operands (only binary
       operations are implemented), except for square root which takes
        one argument (unary operation).
      -The program will stop execution when it runs out of operators and
        return the result so far.
      -Only positive and negative integers with or without decimal values
       are valid operands

  Produces:
    Prints integer value of valid RPN expression. Does not return a specific 
    value. 

=end

############################################
#         #
# HELPERS #
#         #
###########

#define helper function to convert a string
#to an integer value

def stringToInt(stringVal)
  myInt = 0
  sign = 1

  #account for decimal values
  if stringVal.split("").include?(".")

    if stringVal.length == 1 
      return myInt = "!"
    end

    if stringVal.count(".") >= 2
      return myInt = "!"
    end 

 
    splitNumArray = stringVal.split(".")
    
    #integer portion
    integerVal = splitNumArray[0]
    
    #decimal portion
    decStringVal = splitNumArray[1]
    
  else 
    integerVal = stringVal  
  end       
      

  #account for negative numbers
  if integerVal[0] == "-"
    sign = -1
    integerVal[0] = ""
  end  

  
  digitArray = asciiToDigit(integerVal)
  digArrayLength = digitArray.length
  

  #convert digit array to its integer
  #representation
  for i in 0..digArrayLength-1
    myInt += digitArray[i] * (10 ** (digArrayLength - (1+i)))
  end

  #if we have a decimal component, add it in
  if decStringVal
    decArray = asciiToDigit(decStringVal)

    for i in 0..decArray.length-1
      myInt += decArray[i] * (10 ** (-1 * (i+1)))
    end  

  end  

  #return our final result integer
  myInt * sign 

end

#convert numeric ascii string to digit value
def asciiToDigit(asciiString)

  digitArray = Array.new

  #convert ascii string to digit array
  asciiString.each_byte do |digit|
    #if character is not a true digit, set up to fail
    #and return error message
    if digit < "0".ord || digit > "9".ord
      # set special token to cause failure for invalid operands
      return myInt = "!" 
    else
    #we can find a true digit's value by subtracting the 
    #base ascii value of 0   
    digitArray.push(digit - "0".ord)
    end
  end

  digitArray

end  

#define helper function to perform our 
#simple binary operations

def binaryOp (operator, leftOperand, rightOperand)

  case operator
  when "+"
    leftOperand + rightOperand
  when "-"
    leftOperand - rightOperand
  when "*"
    leftOperand * rightOperand
  when "/"
    leftOperand / rightOperand
  end  

end

#define helper to do unary operations

def unaryOp (operator, operand)

  case operator 
  when "sqrt"
      Math.sqrt(operand)
  end      

end  


#define our core subroutine, which will evaluate
#the input string from the command line and print
#its integer value

def computeStringVal(inputStr)

  #if we didn't get any input, just cease
  #execution
  if inputStr == nil
    return
  end  

  #convert input string to array structure
  #for convenient computing
  inputArray = inputStr.split(' ')

  #initialize a stack to hold numbers that 
  #we've already seen separately
  numbersStack = Array.new

   inputArray.each do |current|

    #if we see an operator, perform necessary arithmetic 
    #and place result in the number stack
    if ["+", "-", "*", "/"].include?(current)

      rightOperand = numbersStack.pop
      leftOperand = numbersStack.pop

      #do some error checking

      #if we run out of arguments, end execution
      if leftOperand == nil || rightOperand == nil
        puts "not enough arguments"
        return
      end  

      #if arguments are invalid, end execution
      if leftOperand == "!" || rightOperand == "!"
        puts "invalid number(s)"
        return
      end 

      #do our arithmetic
      newVal = binaryOp(current, leftOperand, rightOperand)

      #put our result back into the stack because
      #we will need it later
      numbersStack.push(newVal)

    elsif current == "sqrt"
    
      operand  = numbersStack.pop

      #error checking for single operand

      #not enough arguments
      if operand == nil 
        puts "not enough arguments"
        return
      end

      #invalid character
      if operand == "!"
        puts "invalid argument"
        return
      end  

      #do our arithmetic
      newVal = unaryOp(current, operand)

      #push result of unary operation back into stack
      numbersStack.push(newVal)


    #otherwise, if we see a number, just convert it to an
    #integer and store it in the stack
    elsif current != nil
      numbersStack.push(stringToInt(current))
    end    

  end 

  #we're done. print our final result
  puts numbersStack.pop

end


############################################
#         #
# MAIN    #
#         #
###########

#Accept input string from the command-line

inputString = ARGV[0]

#if we didn't get anything, just return
if inputString == nil 
  puts "Please use the RPN evaluator with a valid input string in the command line" 
end

#evaluate our string RPN style
computeStringVal(inputString)





