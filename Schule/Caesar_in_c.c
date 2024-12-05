#include<stdio.h>
#include<stdlib.h>

int main()
{
	// Prüfen ob Verschlüsseln oder entschlüsseln erwünscht ist
	printf(" Soll verschlüsselt werden?(y/n): \n");
	char scl;
	scanf(" %c", scl);
	
	if(scl == 'y' || scl == 'y') // Verschlüsseln mit RSA
	{
		// Eingabe Schüsselteil e
		int ePrivat;
		
		printf(" Eingabe e: \n");
		ePrivat = getchar()[255];
		printf(" Erster Teil vom privaten Schlüssel: ", ePrivat);
		
		// Eingabe Schüsselteil N
		int NPrivat;
		
		printf(" Eingabe N: \n");
		NPrivatOef = getchar();
		printf(" Zweiter Teil vom privaten Schlüssel: ", NPrivatOef);
		
		// Eingabe Text
		int text;
		
		printf(" Zahl Text: \n");
		text = getchar();
		printf("So lautet der Text: ", text);
		printf("\n");
		
		verschluesselt = (text ** ePrivat) % NPrivatOef;
		printf(" Der verschlüsselte Text lautet: ", verschluesselt);
	}
	
	else // Entschlüsseln mit RSA
	{
		// prüfen ob entschlüsselt werden soll
		printf(" Soll entschlüsselt werden?(y/n): \n");
		char ents;
		scanf(" %c", ents);
		
		if(ents == 'Y' || ents == 'y')
		{
			// Eingabe öffentlicher Schlüssel
			int dOeffent;
			
			printf(" Eingabe d: \n");
			dOeffent = getchar();
			printf(" Teil des öffentlichen Schlüssels: ", d);
			
			// Eingabe verschlüsselter Text
			int vText;
			
			printf(" Zahl des verschlüsselten Textes: \n");
			vText = getchar();
			printf(" Eingabe verschlüsselter Text: ", vText);
			
			entschluesselt = (vText ** dOeffent) % NPrivatOef;
			
			printf(" Der entschlüsselte Text lautet: ", entschluesselt);
		}
		
		else
		{
			printf("Ende!\n");
		}
	}
	
}
