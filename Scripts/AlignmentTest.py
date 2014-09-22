__author__ = 'Bdesktop'

correct = "LAB: SIL    T UW N AE            R  OW    G  EY JH R EY L  R  OW D Z SIL   F R OH M CH   AY N       AX  SIL   EH N T AX DH AX S IH T  IH F R OH M DH AX N   AO TH IY S T  SIL       AX N AO TH W       EH S  T  SIL"
evaled =  "REC: SIL DH T UW   AE HH EA M JH UA OW UW UH CH HH R    AW AO OW V S SIL P F      N CH R AY N ER AW SIL SIL B EH N T       N  S AX CH UW F      W IH AH N G AO TH EY S CH SIL D G R AH M AO V  W AY AX Z  AX JH SIL"

compare = "SIL T UW . AE UA OW UH CH HH R . AW AO OW V S SO; F . . N CH AY N SIL SIL EH N T . . N S AX CH UW F . . W IH AH N AO TH EY S CH SIL AX M AO V W Z AX JH SIL".split(" ")

def compareAlignments(correctAlignment, evaluationAlignment):
    phoneList = []
    phone = ""
    foundPhoneStart = False

    for i in range(len(correctAlignment)):
        if i < 4:
            continue

        if i > len(correctAlignment) - 4:
            test = 1




        if not correctAlignment[i] == " " and not foundPhoneStart:
            foundPhoneStart = True
            phone += evaluationAlignment[i]
        elif(foundPhoneStart):
            if not evaluationAlignment[i] == " ":
                phone += evaluationAlignment[i]
            else:
                foundPhoneStart = False
                phoneList.append(phone)
                phone = ""

    phoneList.append(phone)         # Append the final phone
    return phoneList

test = compareAlignments(correct, evaled)

print(test)
print(compare)
print(len(test))