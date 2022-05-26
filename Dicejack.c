#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void displayRules(){                                     // Creating a rule book function that the user can read
	printf("\n**********************************************************************************************************\n");
	printf("\t\t\t\t\tRULES\n\n");
	printf("In this game, the both the player and dealer are given an initial dice roll\n");
	printf("The player acts first, and the objective is to get as close to 12 as possible\n");
	printf("If the user goes over 12, they bust and automatically lose their bet\n");
	printf("The dealer stands on numbers 10, 11, and 12. They must hit until they reach one of these values of bust\n");
	printf("This is gambling, so gamble responsibly!\n");
	printf("\n**********************************************************************************************************\n");
}


void prizeSelection() {                                              // Creating a prize selection function that allows the user to redeem a prize
	printf("\nEnter the prize you would like to redeem \n\n");

	char prizes[9][15] =											// 2d array of strings

		{"Buffets", "Rooms", "Spas",
		"Tours", "Club", "Alcohol",
		"Trip", "Free Bets", "Car"};
	
	printf("This is your prize selection: \n");

	for (int i = 0; i < 9; ++i) {								// For loop to display the selection of prizes
		printf("%s \n", prizes[i]);
	}

	int prize;

	
	printf("Enter the prize in the range [0..8]: ");                // Asking the user to pick their prize
	scanf("%d", &prize);
	 
	printf("\nThe prize you redeemed is: %s\n", prizes[prize]);			// Finds the prize and displays what they redeemed
}

int main(void)
{
	char userName[50];
	printf("\t WELCOME TO JONATHAN'S BLACKJACK TABLE!\n");
	printf("\t---------------------------------------\n\n");
	
	printf("Please enter your first name to join the table: ", userName);				// Calls for the user to enter their name.
	scanf("%s", &userName);

	printf("\nHello %s\n", userName);

	int balance = 1000;

	printf("You have a starting balance of: $%d", balance);
	
	
	while (1) {                                                                       // Loop that allows the game to keep running until the user quits.
		int playOrQuit;
		printf("\n\nWhat would you like to do? Select 3 to play, 4 to quit, 5 for the rules, and 6 for prize redemption: ");
		scanf("%d", &playOrQuit);

		if (playOrQuit == 3) {                                                      // If the user presses 3, the game will begin.
			
			printf("\n\t\tLets play!\n");
			printf("---------------------------------------------\n\n");

			int wager; 

			printf("Select the amount you would like to wager: $");
			scanf("%d", &wager);

			if (wager > balance) {
				
				printf("\nInsufficient balance!\n");
				break;
			}

			srand(time(0));
			
			int firstRoll;

			int dealRoll;

			dealRoll = 6 - rand() % 6;												// Dealer gets a random dice roll from 1-6.
			printf("\nThe dealer's number is: %d \n\n", dealRoll);
			
			firstRoll = 6 - rand() % 6;                                           // Player gets a random dice roll from 1-6.
			printf("Your first number is: %d \n", firstRoll);
			
			int sum = firstRoll;

			int sum2 = dealRoll;

			int choice;

			int temp;

			int dealTemp; 

			int newBalance; 

			while (1) {                                                          // Loop that beings after the first dices are rolled.
				
				printf("\nSelect 1 to hit and 2 to stand\n");					// Calling for the user to hit or stand based on their first dice roll.
				scanf("%d", &choice);

				switch (choice) {
				case 1:															// If the user hits, they will press 1.
					temp = 6 - rand() % 6;										// Another dice will be rolled
					printf("The dice rolled: %d\n\n", temp);
					
					sum = sum + temp;											// The new dice roll will keep summing until the user stands or busts.
					printf("Your new sum is: %d\n\n", sum);
					
					if (sum > 12) {												// Busting condition for the user.
						
						printf("You have busted!\n\n");
						balance = balance - wager;
						printf("Your new balance is: $%d", balance);
						
						break;
					}
					continue;
					break;

				case 2:															// Once the user is happy with their number, they press 2 to stand.
					printf("You have chosen to stand\n\n");
					
					while (sum2 < 10) {											// After the user stands, the dealer will begin to roll their dice, and as long as their sum is less than 10, they will continue to roll
						dealTemp = 6 - rand() % 6;								// Once the dealer has 10 - 12, the loop will break and the dealer will stand.
						printf("The dice rolled: %d\n\n", dealTemp);
						
						sum2 = sum2 + dealTemp;
						printf("The dealer's new sum is: %d\n\n", sum2);
						
						if (sum2 > 12) {										// However, if the dealer's sum ends up being more than 12, they bust.
							
							printf("The dealer busted!\n\n");
							break;
						}
					
					}

																				// User's value is compared to the dealer's value to determine the winner. 
					if (sum > sum2 || sum2 > 12) {								// If the user has a higher number than the dealer or the dealer busts, the user wins.
						
						printf("Congrats! You won this hand\n\n");
						
						newBalance = wager * 2;
						balance = balance + newBalance - wager;
						printf("Your new balance is: $%d", balance);

						}
					else if (sum < sum2) {										// If the user has a lower number than the dealer, the dealer wins.
						
						printf("Sorry! You lost this hand\n\n");
						
						balance = balance - wager;
						printf("Your new balance is: $%d", balance);

					}
					else {														// If the user and dealer have the same number, the dealer and user tie and the bet is pushed, or voided.
						printf("You pushed with the dealer on this hand\n");
					}
				}
				break;
			}
		}
		
		else if (playOrQuit == 4) {												// If the user presses 4, the code will terminate.
			printf("Thanks for playing! Hope to see you again soon!\n");
			break;
		}

		else if (playOrQuit == 5) {
		    displayRules();														// Calling the display rules function
			continue;
		}


		else if (playOrQuit == 6) {
			
				if (balance > 2000) {
					prizeSelection();											// Calling the prize selection function if the user has over $2000
				}

				else {
					printf("You must have over $2000 to redeem a prize!\n");
				}

		continue;

		}

		else {																	// Error checking to make sure the user presses 3, 4, 5, or 6. 
			printf("You selected an invalid integer, please try again!\n");
		}
	}

	return 0;
}

