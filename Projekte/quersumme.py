# Funktion Quersumme
def querSum(natZahl):
        zahlString = str(natZahl)
        querSumme = 0
        for zifferBuchstabe in zahlString:
                querSumme = querSumme + int(zifferBuchstabe)
        return querSumme

# Hauptprogramm
natZahl = int(input("Natürliche Zahl (Abbruch: negative Zahl) eingeben: "))
while natZahl >= 0:
        print (natZahl, querSum(natZahl))
        natZahl = int(input("\nNatürl. Zahl (Abbruch: negative Zahl) eingeben: "))
print ("\nEnde der Berechnungen")

