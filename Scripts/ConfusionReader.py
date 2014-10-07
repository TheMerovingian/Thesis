import os
import platform
import shutil

from time import sleep

""" Define System Directory Constants """
if platform.system() == "Windows":
    FILE_START = "E:\\Thesis\\External\\"
    SEPARATOR = "\\"
else:
    FILE_START = "/Volumes/External/"
    SEPARATOR = "/"

# Directory Constants
TRAINING_DIR = str.format("{0}ClassifierTraining{1}", FILE_START, SEPARATOR)

MATRIX_INPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Confusions\\||Output.txt"
MATRIX_OUTPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Confusions\\||Matrix.csv"
ACCURACY_OUTPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Accuracies\\||Accurate.txt"

EXTS = ["MFC", "PLP", "LPD", "FBNK"]
NOISE_LEVELS = ["Clean", "30dB", "15dB", "5dB"]

PHONE_LIST_LOC = TRAINING_DIR + "Training" + SEPARATOR + "SortedPhoneList"

OUTPUT_EXT = "csv"

with open(PHONE_LIST_LOC, 'r+') as fid:
    PHONE_LIST = fid.readlines()

PHONE_LIST = [phone.strip() for phone in PHONE_LIST]

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
        phone = PHONE_LIST.index(key)
        accuracy = '\t'.join(accuracyOut[key])

        outputAccuracy.write(str.format("{0}\t{1}\n", phone, accuracy))


    outputAccuracy.close()