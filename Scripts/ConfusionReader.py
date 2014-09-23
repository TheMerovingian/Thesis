MATRIX_INPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Confusions\\||Output.txt"
MATRIX_OUTPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Confusions\\||Matrix.csv"
ACCURACY_OUTPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Accuracies\\||Accurate.txt"

EXTS = ["MFC", "PLP", "LPD", "FBNK"]
NOISE_LEVELS = ["Clean", "30dB", "15dB", "5dB"]


for ext in EXTS:
    accuracyOut = dict()

    for noiseLevel in NOISE_LEVELS:
        replacement = str.format("{0}_{1}_", noiseLevel, ext)

        fid = open(MATRIX_INPUT.replace("||", replacement), 'r')
        lines = fid.readlines()
        fid.close()

        outputMatrix = open(MATRIX_OUTPUT.replace("||", replacement), 'w')


        for line in lines[-47:-2]:
            data = line.split()
            data = data[1:46]

            outputMatrix.write(",".join(data))
            outputMatrix.write("\n")

            data = line.split()
            phone = data[0]

            if not phone in accuracyOut.keys():
                accuracyOut[phone] = []

            accuracy = data[-1].strip('[').strip(']')
            accuracyOut[phone].append(accuracy.split('/')[0])

        outputMatrix.close()

    outputAccuracy = open(ACCURACY_OUTPUT.replace("||", ext + "_"), 'w')

    for key in accuracyOut.keys():
        phone = key
        accuracy = '\t'.join(accuracyOut[key])

        outputAccuracy.write(str.format("{0}\t{1}\n", phone, accuracy))


    outputAccuracy.close()