# Projektnummer berechnen
# Zeichenkette einlesen
input_string = input("Gib eine Zeichenkette ein: ")

# ASCII-Werte der Zeichen bestimmen und ausgeben
ascii_values = [ord(char) for char in input_string]
print("ASCII-Werte der Zeichen:", ascii_values)

# Summe der ASCII-Werte berechnen
ascii_sum = sum(ascii_values)
print("Summe der ASCII-Werte:", ascii_sum)

