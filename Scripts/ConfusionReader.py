confusionMatrix = "F:\\Thesis\\External\\ClassifierTraining\\Results\\Confusions\\||Confusion.txt"
output = "F:\\Thesis\\External\\ClassifierTraining\\Results\\Confusions\\||Matrix.csv"

EXTS = ["MFC", "PLP", "STFT", "STFTSorted"]

for ext in EXTS:
    fid = open(confusionMatrix.replace("||", ext), 'r')
    lines = fid.readlines()
    fid.close()

    outputFile = open(output.replace("||", ext), 'w')

    for line in lines:
        data = line.split()
        data = data[1:46]

        outputFile.write(",".join(data))
        outputFile.write("\n")

    outputFile.close()