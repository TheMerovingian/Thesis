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
PHONE_LIST_LOC = TRAINING_DIR + "Training" + SEPARATOR + "SortedPhoneList"

INDEX_OUTPUT = "E:\\Thesis\\External\\ClassifierTraining\\Results\\Indices.txt"

with open(PHONE_LIST_LOC, 'r+') as fid:
    PHONE_LIST = fid.readlines()

PHONE_LIST = [phone.strip() for phone in PHONE_LIST]

TYPE_DICTIONARY = {"Vowel":["IY", "IH", "IA", "EY", "EH", "AE", "EA", "AA", "AO", "OW", "UH", "UW", "UA", "AH", "ER", "AX"],
                   "Diphthong":["AY", "OY", "AW", "OH"],
                   "Stop":["P", "B", "T", "D", "K", "G"],
                   "Affricate":["CH", "JH"],
                   "Nasal":["M", "N", "NG"],
                   "Liquid":["L", "R"],
                   "Fricative":["F", "V", "TH", "DH", "S", "Z", "SH", "ZH", "HH"],
                   "Glide":["Y", "W"],
                   "Silence":["SIL"]}

INDEX_DICTIONARY = dict()

for key in TYPE_DICTIONARY.keys():
    INDEX_DICTIONARY[key] = []

    for phone in TYPE_DICTIONARY[key]:
        INDEX_DICTIONARY[key].append(PHONE_LIST.index(phone))

with open(INDEX_OUTPUT, 'w') as indexFile:
    output = ""

    for key in INDEX_DICTIONARY.keys():
        output += key
        for index in INDEX_DICTIONARY[key]:
            output += ',' + str(index)
        output += "\n"

    indexFile.write(output)
