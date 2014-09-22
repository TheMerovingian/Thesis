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
EVAL_DIR = str.format("{0}Results{1}", TRAINING_DIR, SEPARATOR)
MLF_DIR = str.format("{0}MLFs{1}", TRAINING_DIR, SEPARATOR)

MLF_EVAL = MLF_DIR + "Eval||Phones.mlf"
MLF_SEPARATOR = "\t"

TARGET_OUTPUT = str.format("{0}NN{1}Targets{1}", TRAINING_DIR, SEPARATOR)
TRAINING_OUTPUT = str.format("{0}NN{1}Eval{1}", TRAINING_DIR, SEPARATOR)

CLASSIFIER_EXTS = [".mfc",".fbnk", ".lpd", ".plp"]
NOISE_LEVELS = ["5dB"]

PHONE_LIST_LOC = TRAINING_DIR + "Training" + SEPARATOR + "SortedPhoneList"

OUTPUT_EXT = "csv"

with open(PHONE_LIST_LOC, 'r+') as fid:
    phones = fid.readlines()

PHONE_LIST = [phone.strip() for phone in phones]
PHONE_LIST.append('.')

def buildTargets():
    MLF = MLF_EVAL.replace("||", "")

    with open(MLF, 'r+') as fid:
        fid.readline()                  # Skip opening line

        for line in fid:
            line = line.strip()

            if line.startswith('"'):
                filepath = line.strip('"')
                filename = filepath.split('/')[-1]

                if "A010A" in filename:
                    test = 0

                newFilename = filename.replace('lab', OUTPUT_EXT)
                newFilepath = str.format("{0}{1}", TARGET_OUTPUT, newFilename)
                targetFile = open(newFilepath, 'w')

                debugList = []


            elif line == '.':
                targetFile.close()
                continue

            else:
                currentPhone = line.split(MLF_SEPARATOR)[2]
                phones = PHONE_LIST.copy()
                output = ""

                debugList.append(currentPhone)

                for phone in phones:
                    if phone == currentPhone:
                        output += str(1) + ','
                    else:
                        output += str(0) + ','

                targetFile.write(output.strip(',') + "\n")


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


buildTargets()

for noiseLevel in NOISE_LEVELS:
    for ext in CLASSIFIER_EXTS:
        ext = ext.lstrip('.').upper()

        file = str.format("{0}{1}_{2}_Output.txt", EVAL_DIR, noiseLevel, ext)

        with open(file, 'r+') as fid:
            correct = ""
            eval = ""
            evaluate = False

            for line in fid:
                line = line.strip()

                if line.startswith("Aligned"):
                    outputFilename = line.split("/")[-1].replace('rec', OUTPUT_EXT)
                    outputFilename = str.format("{0}{1}", TRAINING_OUTPUT, outputFilename)
                    outputFile = open(outputFilename, 'a+')
                    correct = ""
                    eval = ""

                elif line.startswith("LAB"):
                    correct = line
                elif line.startswith("REC"):
                    eval = line
                    evaluate = True
                elif evaluate:
                    output = ""
                    phones = compareAlignments(correct, eval)
                    lastPhone = ""

                    for phone in phones:
                        if phone == "" or phone == " ":
                            phone = '.'

                        if phone == lastPhone:
                            pass
                            #continue

                        output += str(PHONE_LIST.index(phone)) + ','

                        lastPhone = phone

                    outputFile.write(output.strip(',') + "\n")

                    evaluate = False

                    outputFile.close()
