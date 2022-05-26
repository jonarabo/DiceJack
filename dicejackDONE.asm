.data 

rules: .asciiz "\n**********************************************************************************************************\n\t\t\t\t\tRULES\n\nIn this game, both the player and dealer are given an initial dice roll\nThe player acts first, and the objective is to get as close to 16 as possible\nIf the user goes over 16, they bust and automatically lose their bet\nThe dealer stands on numbers 13, 14, 15, and 16. They must hit until they reach one of these values or bust\nThis is gambling, so gamble responsibly!\n**********************************************************************************************************\n"

intro: .asciiz "\t WELCOME TO JONATHAN'S DICEJACK TABLE!\n"
format1: .asciiz "\t---------------------------------------\n\n"

prompt1: .asciiz "Please enter your first name to join the table: "
userName: .space 50
prompt2: .asciiz "\nHello "
prompt3: .asciiz "\nYou have a starting balance of: $"

newline: .asciiz "\n"

startGame: .asciiz "\n\nWhat would you like to do? Select 3 to play, 4 to quit, 5 for the rules, and 6 for prize redemption: "

ifPrompt: .asciiz "\n\t\tLets play!\n"
ifFormat: .asciiz "---------------------------------------------\n\n"

wagerPrompt: .asciiz "Select the amount you would like to wager: $"

dealRoll: .asciiz "\nThe dealer's number is: "
firstRoll: .asciiz "\nYour first number is: "

choice: .asciiz "\nSelect 1 to hit and 2 to stand\n"

hitRoll: .asciiz "\nThe dice rolled: " 
newSum: .asciiz "\nYour new sum is: "
dealSum: .asciiz "The dealer's new sum is: "

error1: .asciiz "\nInsufficient balance!\n"
error2: .asciiz "You selected an invalid integer, please try again!\n"

standPrompt: .asciiz "You have chosen to stand\n\n"

playerBustPrompt: .asciiz "\nYou have busted!\n\n"

dealBustPrompt: .asciiz "\n\nThe dealer busted!\n\n"

winPrompt: .asciiz "\n\nCongrats! You won this hand\n\n"

newBal: .asciiz "\nYour new balance is: $"

losePrompt: .asciiz "\n\nSorry! You lost this hand\n\n"

pushPrompt: .asciiz "\n\nYou pushed with the dealer on this hand\n"

endPrompt: .asciiz "Thanks for playing! Hope to see you again soon!\n"

prizesPrompt: .asciiz "\nEnter the prize you would like to redeem \n\n"
prizeErrPrompt: .asciiz "\nYou must have over $2000 to redeem a prize!\n"

displayPrizes: .asciiz "This is your prize selection: \n"

redemptionPrompt: .asciiz "\n\nEnjoy your prize! Keep playing to earn another one!"

prize1: .asciiz "[0][0] Buffets "
prize2: .asciiz "[0][1] Rooms "
prize3: .asciiz "[0][2] Spas "
prize4: .asciiz "[1][0] Tours "
prize5: .asciiz "[1][1] Club "
prize6: .asciiz "[1][2] Alcohol "
prize7: .asciiz "[2][0] Trip "
prize8: .asciiz "[2][1] Free Bets "
prize9: .asciiz "[2][2] Car "

			# Inspiration and guide to help me write a 2D array of string that I can loop over. Source: https://stackoverflow.com/questions/26198491/how-do-you-print-an-array-of-strings-in-mips

prizesArray:                       
.word   prize1, prize2, prize3, 
.word	prize4, prize5, prize6, 
.word	prize7, prize8, prize9

columns: .word 3

rowPrompt: .asciiz "\nEnter a row between 0 and 2: "
colPrompt: .asciiz "\nEnter a column between 0 and 2: "

printPrize: .asciiz "\nThe prize you chose is: "


.text


	#The start function is where the user is greeted and asked for their name. Also displays their starting balance
start:
	li $v0, 4			
	la $a0, intro
	syscall 

	li $v0, 4
	la $a0, format1
	syscall

	li $v0, 4
	la $a0, prompt1
	syscall

	li $v0, 8		# reading the string the user enters
	la $a0, userName	
	li $a1, 50 		# 50 max characters to read
	syscall

	li $v0, 4
	la $a0, prompt2
	syscall

	li $v0, 4
	la $a0, userName
	syscall


	li $v0, 4
	la $a0, prompt3
	syscall

	addi $s5, $zero, 1000        # Storing $1000 into their starting balance
	li $v0, 1
	move $a0, $s5 		     # Copying it into $a0 to print out	
	syscall

	li $v0, 4
	la $a0, newline
	syscall

MainLoop:		# MainLoop is the main loop that the other functions jump to. Allows for the game to continue to be played until terminated by the user.
	
	li $v0, 4
	la $a0, startGame
	syscall

	li $v0, 5   		# reading user input
	syscall 
	move $t2, $v0		# copying it to $t2

	li $v0, 4
	la $a0, newline
	syscall 

	# branching conditions based on what the user inputs
	beq $t2, 3, Play     # Pressing 3 will play the game
	beq $t2, 4, quitGame # Pressing 4 will quit the game and terminate the program
	beq $t2, 5, ruleBook # Pressing 5 will display the rules to the user
	beq $t2, 6, prizeRedeem # Pressing 6 will take the user to the prize redemption
	blt $t2, 3, errorChecking # Any other integer will display an error message and ask the user to enter try again
	bgt $t2, 6, errorChecking

Play: 			# If the user presses 3, the program branches to this function. It allows the user to place a wager as well as see both the dealer and player's initial roll
	
	li $v0, 4
	la $a0, ifPrompt
	syscall 

	li $v0, 4
	la $a0, ifFormat
	syscall

	li $v0, 4
	la $a0, wagerPrompt
	syscall

	li $v0, 5		# Calls for user to input their wager
	syscall
	move $t3, $v0

	bgt $t3, $s5, terminate  #Branching statement that terminates the program if the wager is greater than the balance. 
	
	li $v0, 4
	la $a0, dealRoll
	syscall
								# generating the dealer's first roll (stored in $s2)
	li $a1, 8 #upper bound is 8
	li $v0, 42 #generates a random number 0-7
	syscall 

	addi $t1, $a0, 1 #add 1 and store it in t1
	move $a0, $t1 #makes a copy in $a0
	move $s2, $a0 #makes a copy in $s2

	li $v0, 1 #prints that integer
	syscall 

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, firstRoll
	syscall
								# generating the player's first roll (stored in $s0)
	li $a1, 8         
	li $v0, 42 
	syscall 

	addi $t1, $a0, 1 
	move $a0, $t1
	move $s0, $t1
 
	li $v0, 1 
	syscall


	li $v0, 4
	la $a0, newline
	syscall



GameLoop: # Loop that allows the user to hit or stand based on their value

	li $v0, 4
	la $a0, choice
	syscall 

	li $v0, 5   			# User decision on if they want to keep rolling or stand
	syscall 
	move $t4, $v0
					# branching conditions based on user's input 
					
	beq $t4, 1, Hit              #If the user presses 1, branches to the hit function
	beq $t4, 2, Stand		#If the user presses 2, branches to the stand function


Hit: # Function that will generate a random roll for the player each time it is called

	jal hitSound                  # Playing the hit sound each time the user hits
	
	li $v0, 4
	la $a0, hitRoll
	syscall

	li $a1, 8 			# Generates another random number for the player
	li $v0, 42 
	syscall 

	addi $t2, $a0, 1 
	move $a0, $t2 

	li $v0, 1 
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, newSum
	syscall

			
	add $s0, $t2, $s0		# Sums the value of their first number and each dice roll that they get	
	move $a0, $s0				#moving to $a0 to allow the program to print the integer
	li $v0, 1
	syscall 

	bgt $a0, 16, playerBust			#if the user continues to hit and their sum is greater than 16, branches to playerBust

	li $v0, 4
	la $a0, newline
	syscall

	j GameLoop				# Continuously loops until the user chooses to stand or if the user busts

Stand: 					# Jumps to this function when the user stands
	li $v0, 4
	la $a0, standPrompt
	syscall


DealDraw:				# Continues with this function, the dealer continues to roll dice
	li $v0, 4
	la $a0, hitRoll
	syscall

	li $a1, 8                     # Generates a random dice roll
	li $v0, 42 
	syscall 

	addi $t2, $a0, 1 
	move $a0, $t2                 # Copying in $a0 so it can be printed

	li $v0, 1 
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, dealSum
	syscall


	add $s2, $t2, $s2       # Sums the values that the dealer's dice rolls with their first number
	move $a0, $s2           # Copying in $a0 so it can be printed
	li $v0, 1				# Prints the integer
	syscall 

						# Branching conditions based on the outcome of the game

	blt $s2, 13, DealDraw			# if the dealer has less than 14, the program will branch back up and the dealer will continue to draw
	bgt $s2, 16, DealBust			# if the dealer has greater than 16, the program will branch to the dealbust function
	bgt $s0, $s2, userWin			# if the user's sum is greater than the dealer's sum, the program will branch to the userWin function
	bgt $s2, $s0, dealWin			# if the dealer's sum is greater than the user's sum, the program will branch to the dealWin function
	beq $s0, $s2, pushFunc			# if both sum's are equal, the program will branch to the pushFunc function
	
	j MainLoop

playerBust: 				# function that tells the player that they busted
	li $v0, 4
	la $a0, newline
	syscall


	li $v0, 4
	la $a0, playerBustPrompt
	syscall

	jal calcBalanceLose            # Jumps to the calcBalanceLose function, prints their new balance, and then continues on with the code in this function

	j loseSound 			# Jumps to the loseSound function, which will play the losing sound, and ask what the user wants to do next


DealBust:				# function that tells the player that the dealer busted

	li $v0, 4
	la $a0, dealBustPrompt
	syscall

	jal calcBalanceWin               # Jumps to the calcBalanceWin function, prints their new balance, and then continues on with the code in this function
	
	j winSound 			# Jumps to the winSound function, which will play the winning sound, and ask what the user wants to do next


ruleBook:						#function that displays the rules of the game
	li $v0, 4
	la $a0, rules
	syscall

	j MainLoop

prizeRedeem: 						# function that allows the user to redeem a prize
	li $v0, 4
	la $a0, prizesPrompt
	syscall

	li $v0, 4
	la $a0, displayPrizes
	syscall

	la $a1, prizesArray                          # loading the address of the array into $a1

	addi $t0, $zero, 0                          # setting $t0 to 0

printArray: 					# Essentially a for loop that will continue to loop until the conditions are met. Prints all prizes in a list for the user to see
	bgt $t0, 8, prizeClaim
	addi $t0, $t0, 1                        # incrementing $t0 by 1
	li $v0, 4
	lw $a0, 0($a1)                         # prints the contents of the array, starting at the string at 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $a1, $a1, 4                   # increases the offset by 4 to print the next string

	j printArray


prizeClaim:			#function that will allow the user to select their prize. 

	la $a1, prizesArray         # loading the address of the array into $a1
	lw $t2, columns             # loading the number of columns into $t2
	
	li $v0, 4
	la $a0, rowPrompt
	syscall
	
	li $v0, 5                    # Calling for the user to enter the row of their prize
	syscall 
	move $t7, $v0                # Making a copy of it in $t7

	li $v0, 4                     
	la $a0, colPrompt
	syscall

	li $v0, 5                   # Calling for the user to enter the column of their prize
	syscall 
	move $t8, $v0                     # Making a copy of it in $t7

	ble $s5, 2000, prizeError         # If the balance is less than $2000, the program will not allow the user to redeem their prize
	
	li $v0, 4
	la $a0, printPrize
	syscall	

 	jal arrAddress
 	
 	li $v0, 4 		# prints the string
	lw $a0, 0($t9)     	# after the operations are performed, the contents are loaded in $a0 to be printed 
	syscall
 	
 	jal calcBalanceRedeem      # after the string is printed, the program will jump to this function, which will subtract $1000 from their balance and print their new balance.
 	
	li $v0, 4
	la $a0, redemptionPrompt
	syscall

	j MainLoop


		#Formula SOURCE: https://youtu.be/frjWApYntIA
		
arrAddress: # Formula of Row-Major: address = baseAddress + (rowIndex * columnSize + columnIndex) * dataSize   
	mul $t9, $t7, $t2     # rowIndex * columnSize
	add $t9, $t9, $t8     # the product of rowIndex * columnSize added to columnIndex
	sll $t9, $t9, 2       # shifting that value by 2 to multiply by the datasize
	add $t9, $t9, $a1     # baseAddress of the array is then added to the total and stored in the $t9 register
	
	jr $ra



userWin:                       # Function that will be executed whenever the user wins
	li $v0, 4
	la $a0, winPrompt
	syscall 

	jal calcBalanceWin        # Calculates the balance of the user after their win, and will continue on with the remaining code after the calculations are performed

	j winSound               # Plays a specific sound whenever the user wins

dealWin:			# Function that will be executed whenever the dealer wins
	li $v0, 4
	la $a0, losePrompt
	syscall

	jal calcBalanceLose  # Calculates the balance of the user after their loss, and will continue on with the remaining code after the calculations are performed

	j loseSound         # Plays a specific sound whenever the user loses

pushFunc:                    # Function that will be executed whenever the dealer and user have the same value, the game is essentially voided and nothing happened.
	li $v0, 4
	la $a0, pushPrompt
	syscall
	
	j MainLoop

	#ALL CALC BALANCE FUNCTIONS ARE INSPIRATION AND BORROWED AND SLIGHTLY MODIFIED FROM THE SOURCE:  https://youtu.be/E0PHijf0P7g

calcBalanceWin: # Function that will calculate the balance of the user based on if they win. 

	addi $sp, $sp, -8            # allocating space in the stack
	
	add $s5, $s5, $t3           # adding their wager on to their current balance
	
	sw $s5, 0($sp)             # storing that new value in the stack
	sw $ra, 4($sp)             # storing the return address in the stack

	li $v0, 4
	la $a0, newBal
	syscall

	jal printBal              # Prints their new balance 

	lw $s5, 0($sp)           # restoring the balance 
	lw $ra, 4($sp)           # restoring the return address
	addi $sp, $sp, 8         # restoring the stack

	jr $ra

calcBalanceLose: # Function that will calculate the balance of the user based on if they lose. 

	addi $sp, $sp, -8
	
	sub $s5, $s5, $t3        # subtracting their wager on to their current balance
	
	sw $s5, 0($sp)
	sw $ra, 4($sp)

	li $v0, 4
	la $a0, newBal
	syscall

	jal printBal               # prints their new balance after losing

	lw $s5, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	jr $ra


calcBalanceRedeem: # Function that will subtract $1000 from the user's balance when they successfully redeem a prize.
	addi $sp, $sp, -8
	
	sub $s5, $s5, 1000                # subtracting $1000 from their current balance
	
	sw $s5, 0($sp)
	sw $ra, 4($sp)

	li $v0, 4
	la $a0, newBal
	syscall

	jal printBal                   # prints their balance after redeeming a prize

	lw $s5, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	jr $ra

printBal:                              # universal printBal function that is called in the stack to eliminate code redundancy
	li $v0, 1
	move $a0, $s5
	syscall 
	
	jr $ra

winSound: #Function that will play a sound if the user wins 

	li $v0, 31
	li $a0, 60 # pitch
	li $a1, 750 # duration
	li $a2, 10 # instrument
	li $a3, 100 # volume
	syscall 

	j MainLoop

loseSound: #function that will play a sound if the user loses 

	li $v0, 31
	li $a0, 40
	li $a1, 750
	li $a2, 64
	li $a3, 100
	syscall 

	j MainLoop

hitSound: #function that will play a sound whenever the user hits

	li $v0, 31
	li $a0, 61
	li $a1, 675
	li $a2, 8
	li $a3, 100
	syscall 

	jr $ra

# All functions below are error checking or termination functions

prizeError:                     # Displays an error if the user attempts to redeem a prize without a balance greater than $2000

	li $v0, 4
	la $a0, prizeErrPrompt
	syscall

	j MainLoop

errorChecking:                  # Displays an error if the user attempts to enter a value other than 3, 4, 5, or 6 when prompted

	li $v0, 4
	la $a0, error2
	syscall 
	
	j MainLoop


quitGame:						# If the user presses 4, the code will jump to this function. It terminates the program
	li $v0, 4
	la $a0, endPrompt
	syscall 
	j end

end:
	li $v0, 10
	syscall

terminate: 					# function that terminates the program if the user attempts to wager more than their balance
	li $v0, 4
	la $a0, error1
	syscall

	li $v0, 10
	syscall



# ALL SOURCES USED:
# https://stackoverflow.com/questions/26198491/how-do-you-print-an-array-of-strings-in-mips
# https://youtu.be/frjWApYntIA
# https://youtu.be/E0PHijf0P7g
