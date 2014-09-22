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
MLF_DIR = str.format("{0}MLFs{1}", TRAINING_DIR, SEPARATOR)
MLF_EVAL = MLF_DIR + "Eval||Phones.mlf"

TARGET_OUTPUT = str.format("{0}NN{1}Targets{1}", TRAINING_DIR, SEPARATOR)
TRAINING_OUTPUT = str.format("{0}NN{1}Training{1}", TRAINING_DIR, SEPARATOR)

MLF_SEPARATOR = "\t"
MLF_GENERATED_SEPARATOR = " "

CLASSIFIER_EXTS = [".mfc",".fbnk", ".lpd", ".plp"]
NOISE_LEVELS = ["Clean"]

PHONE_LIST = []
PHONE_LIST_LOC = TRAINING_DIR + "Training" + SEPARATOR + "SortedPhoneList"

OUTPUT_EXT = "csv"

with open(PHONE_LIST_LOC, 'r+') as fid:
    PHONE_LIST = fid.readlines()

PHONE_LIST = [phone.strip() for phone in PHONE_LIST]


def buildTargets():
    MLF = MLF_EVAL.replace("||", "")

    with open(MLF, 'r+') as fid:
        fid.readline()                  # Skip opening line

        for line in fid:
            line = line.strip()

            if line.startswith('"'):
                filepath = line.strip('"')
                filename = filepath.split('/')[-1]
                newFilename = filename.replace('lab', OUTPUT_EXT)
                newFilepath = str.format("{0}{1}", TARGET_OUTPUT, newFilename)
                targetFile = open(newFilepath, 'w')

            elif line == '.':
                targetFile.close()
                continue

            else:
                currentPhone = line.split(MLF_SEPARATOR)[2]
                phones = PHONE_LIST.copy()
                output = ""

                for phone in phones:
                    if phone == currentPhone:
                        output += str(1) + ','
                    else:
                        output += str(0) + ','

                targetFile.write(output.strip(',') + "\n")

def buildTrainingSets():
    """
    Clear the training set folder prior to running, otherwise there will be issues with appending
    :return:
    """
    for noiseLevel in NOISE_LEVELS:
        for ext in CLASSIFIER_EXTS:
            ext = ext.lstrip('.').upper()

            MLF = MLF_EVAL.replace("||", str.format("_{0}_{1}_", noiseLevel, ext))

            with open(MLF, 'r+') as fid:
                fid.readline()                  # Skip opening line

                for line in fid:
                    line = line.strip()

                    if line.startswith('"'):
                        filepath = line.strip('"')
                        filename = filepath.split('/')[-1]
                        newFilename = filename.replace('rec', OUTPUT_EXT)
                        newFilepath = str.format("{0}{1}", TRAINING_OUTPUT, newFilename)
                        trainingFile = open(newFilepath, 'a+')

                        output = ""
                        lastPhone = ""

                    elif line == '.':
                        trainingFile.write(output.strip(',') + "\n")
                        trainingFile.close()
                        continue

                    else:
                        currentPhone = line.split(MLF_GENERATED_SEPARATOR)[2]

                        if lastPhone == currentPhone:
                            continue
                        output += str(PHONE_LIST.index(currentPhone)) + ','

                        lastPhone = currentPhone

#buildTargets()
buildTrainingSets()


