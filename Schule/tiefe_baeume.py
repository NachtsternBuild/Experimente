from kraftbaum import *

def tiefer_baum(baum):
    if baum is None:
        return 0
    else:
        linke_tiefe = tiefer_baum(baum[1])
        rechte_tiefe = tiefer_baum(baum[2])
        return 1 + max(linke_tiefe, rechte_tiefe)

def baum_ebnen_in(baum):
    if baum is None:
        return []
    else:
        return baum_ebnen_in(baum[1]) + [baum[0]] + baum_ebnen_in(baum[2])

def baum_ebnen_pre(baum):
    if baum is None:
        return []
    else:
        return [baum[0]] + baum_ebnen_pre(baum[1]) + baum_ebnen_pre(baum[2])

def baum_ebnen_post(baum):
    if baum is None:
        return []
    else:
        return baum_ebnen_post(baum[1]) + baum_ebnen_post(baum[2]) + [baum[0]]

# main    
# 1.
baum = [1, [2, [4, None, None], None], [3, None, None], [6, [9, 12, 40, [10, None, None, 8], 4]]]
tiefe = tiefer_baum(baum)
print("Die Tiefe des Baums ist:", tiefe)  # Ausgabe: Die Tiefe des Baums ist: 3

# 2.
baum = [1, [2, [4, None, None], None], [3, None, None]]

print("In-Order:", baum_ebnen_in(baum))  # Ausgabe: In-Order: [4, 2, 1, 3]
print("Pre-Order:", baum_ebnen_pre(baum))  # Ausgabe: Pre-Order: [1, 2, 4, 3]
print("Post-Order:", baum_ebnen_post(baum))  # Ausgabe: Post-Order: [4, 2, 3, 1]

# 3.
liste = [4, 2, 1, 3]
baum = liste_zu_baum(liste)
print("Baum:", baum)  # Ausgabe: Baum: [[[None, 4, None], 2, None], 1, [[None, 3, None], 3, None]]

