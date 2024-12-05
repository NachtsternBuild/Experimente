#include <stdio.h>

// Algorithmus um (c**e) mod N zu berechnen
long long power_mod(long long base, long long exponent, long long mod) 
{
    long long result = 1;
    
    while (exponent > 0) 
    {
        if (exponent % 2 == 1) 
        {
            result = (result * base) % mod;
        }

        base = (base * base) % mod;
        exponent /= 2;
    }

    return result;
}

int main()
{
    char scl;
    printf("Soll verschlüsselt werden? (y/n): \n");
    scanf(" %c", &scl);

    if (scl == 'y' || scl == 'Y') // Verschlüsseln mit RSA
    {
        // Eingabe Schüsselteil e
        int ePrivat;
        printf("Eingabe e: \n");
        scanf("%d", &ePrivat);
        printf("Erster Teil vom privaten Schlüssel: %d \n", ePrivat);

        // Eingabe Schüsselteil N
        int nPrivatOef;
        printf("Eingabe N: \n");
        scanf("%d", &nPrivatOef);
        printf("Zweiter Teil vom privaten Schlüssel: %d \n", nPrivatOef);

        // Eingabe Text
        long long text;
        printf("Zahl Text: \n");
        scanf("%lld", &text);
        printf("So lautet der Text: %lld \n", text);

        // Ausgabe und Berechnung des verschlüsselten Textes
        long long resultEnt = power_mod(text, ePrivat, nPrivatOef);
        printf("Der verschlüsselte Text lautet: %lld \n", resultEnt);

        // prüfen ob entschlüsselt werden soll
        printf("Soll entschlüsselt werden? (y/n): \n");
        char entsver;
        scanf(" %c", &entsver);
        
        if (entsver == 'Y' || entsver == 'y')
        {
            // Eingabe öffentlicher Schlüssel
            int dOeffent;
            printf("Eingabe d: \n");
            scanf("%d", &dOeffent);
            printf("Teil des öffentlichen Schlüssels: %d \n", dOeffent);

            // Eingabe Schüsselteil N
            int nOeffent;
            printf("Eingabe N: \n");
            scanf("%d", &nOeffent);
            printf("Zweiter Teil vom öffentlichen Schlüssel: %d \n", nOeffent);

            // Eingabe verschlüsselter Text
            long long vText;
            printf("Zahl des verschlüsselten Textes: \n");
            scanf("%lld", &vText);
            printf("Eingabe verschlüsselter Text: %lld \n", vText);

            // Ausgabe und Berechnung des Entschlüsselten Textes
            long long resultVer = power_mod(vText, dOeffent, nOeffent);
            printf("Der entschlüsselte Text lautet: %lld \n", resultVer);
        }
        else
        {
            printf("Ende!\n");
        }
    }
    else // Entschlüsseln mit RSA
    {
        // prüfen ob entschlüsselt werden soll
        printf("Soll entschlüsselt werden? (y/n): \n");
        char ents;
        scanf(" %c", &ents);
        if (ents == 'Y' || ents == 'y')
        {
            // Eingabe öffentlicher Schlüssel
            int dOeffent;
            printf("Eingabe d: \n");
            scanf("%d", &dOeffent);
            printf("Teil des öffentlichen Schlüssels: %d \n", dOeffent);

            // Eingabe Schüsselteil N
            int nOeffent;
            printf("Eingabe N: \n");
            scanf("%d", &nOeffent);
            printf("Zweiter Teil vom öffentlichen Schlüssel: %d \n", nOeffent);

            // Eingabe verschlüsselter Text
            long long vText;
            printf("Zahl des verschlüsselten Textes: \n");
            scanf("%lld", &vText);
            printf("Eingabe verschlüsselter Text: %lld \n", vText);

            // Ausgabe und Berechnung des Entschlüsselten Textes
            long long resultVer = power_mod(vText, dOeffent, nOeffent);
            printf("Der entschlüsselte Text lautet: %lld \n", resultVer);
        }
        else
        {
            printf("Ende!\n");
        }
    }

    return 0;
}

