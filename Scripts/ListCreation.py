import os
import platform
import shutil

from time import sleep

""" Define System Directory Constants """
if platform.system() == "Windows":
    FILE_START = "J:\\"
    SEPARATOR = "\\"
else:
    FILE_START = "/Volumes/External/"
    SEPARATOR = "/"

# Directory Constants
TRAINING_DIR = str.format("{0}ClassifierTraining{1}", FILE_START, SEPARATOR)
TRAINING_AUDIO_DIR = str.format("{0}ConvertData{1}ThesisData{1}Desk{1}Testing{1}Development{1}", FILE_START, SEPARATOR)
SCRIPT_DIR = str.format("{0}Lists{1}", TRAINING_DIR, SEPARATOR)
CLASSIFIER_DIR = str.format("{0}Classifiers{1}", TRAINING_DIR, SEPARATOR)
DATA_DIR = str.format("{0}ConvertData{1}", FILE_START, SEPARATOR)
CONFIG_DIR = str.format("{0}Configs{1}", TRAINING_DIR, SEPARATOR)
HMM_DIR = str.format("{0}HMMs{1}", TRAINING_DIR, SEPARATOR)

# Extension Constants
MFC_EXT = ".mfc"
AUDIO_EXT = ".wav"
PHONEME_EXT = ".phn"
LAB_EXT = ".lab"
CLASSIFIER_EXTS = [".stft", ".lpc", ".mfc", ".nnmf"]

# Script File Extension
SCRIPT_EXT = ".scp"

# Master Label File Extension
MLF_EXT = ".mlf"

# Phoneme Constants
SILENCE_PHN = "sil"

# Config File Locations
# TODO: Actually write configs
MFC_CONVERT_CONFIG = CONFIG_DIR + "MFC_Convert_Config.ini"
HCOMPV_CONFIG = CONFIG_DIR + "||_HCompV_Config.ini"
HCOMPV_MFC_CONFIG = CONFIG_DIR + "MFC_HCompV_Config.ini"
PROTO_CONFIG = TRAINING_DIR + "Training" + SEPARATOR + "MFCProto"
HEREST_CONFIG = CONFIG_DIR + "Reestimation_Config.ini"

# Phoneme File location
PHONE_LOC = TRAINING_DIR + "Training" + SEPARATOR + "Monophones0"

# Sleep length
SLEEP_S = 3

# Number of training iterations
TRAINING_COUNT = 9

def listAllFiles(dir, ext):
    return [name for name in [f for r,d,f in os.walk(dir)][0] if name.lower().endswith(ext.lower())]

def buildFileStructure():

    for ext in CLASSIFIER_EXTS:
        ext = ext.lstrip('.').upper()
        dir = str.format("{0}{1}", HMM_DIR, ext)
        if (not os.path.exists(dir)):
            os.mkdir(dir)

        for i in range(TRAINING_COUNT+1):
            subdir = str.format("{0}{1}hmm{2}", dir, SEPARATOR, i)
            if (not os.path.exists(subdir)):
                os.mkdir(subdir)

def createLabFiles():
    """
    Recursively traverses the entire audio data directory looking for .phn files and copies them into a .lab file if it
    doesn't already exist.
    """
    for root, subdirs, files in os.walk(TRAINING_AUDIO_DIR):
        for file in files:
            [name, ext] = file.split(".")
            phnFile = os.path.join(root, file)
            labFile = str.format("{0}{1}{2}", CLASSIFIER_DIR, name, LAB_EXT)

            if phnFile.lower().endswith(PHONEME_EXT) and not os.path.isfile(labFile):
                shutil.copyfile(phnFile, labFile)


""" Generate WAV -> MFC list """
def generateConversionList():
    # Clear WAV -> MFC conversion file, to allow appending
    wavConvertFile = str.format("{0}{1}{2}", SCRIPT_DIR, "WAV_MFC_Conversion_List", SCRIPT_EXT)
    open(wavConvertFile, 'w').close()

    for folder in os.listdir(TRAINING_AUDIO_DIR):

        dir = str.format("{0}{1}{2}", TRAINING_AUDIO_DIR, folder, SEPARATOR)
        files = listAllFiles(dir, AUDIO_EXT)

        fid = open(wavConvertFile, 'a+')

        for file in files:
            [name, _] = file.split('.')

            output = str.format("{0}{1} {2}{3}{4}",
                        dir,
                        file,
                        CLASSIFIER_DIR,
                        name,
                        MFC_EXT)

            fid.write(output + "\n")

        fid.close()


""" Classifier Training Lists """
def generateClassifierLists():
    for ext in CLASSIFIER_EXTS:
        ext = ext.lstrip('.').upper()
        listFile = str.format("{0}{1}_Training_List.scp", SCRIPT_DIR, ext)

        files = listAllFiles(CLASSIFIER_DIR, ext)

        fid = open(listFile, 'w')

        for file in files:
            fid.write(str.format("{0}{1}\n", CLASSIFIER_DIR, file))

        fid.close()


""" Master Label File Creation """
def generateMLF():
    MLFFile = str.format("{0}{1}{2}", SCRIPT_DIR, "phones0", MLF_EXT)

    # Overwrite the MLF file
    fid = open(MLFFile, 'w')
    fid.write("#!MLF!#\n")
    fid.close()

    for folder in os.listdir(TRAINING_AUDIO_DIR):

        dir = str.format("{0}{1}{2}", TRAINING_AUDIO_DIR, folder, SEPARATOR)
        files = listAllFiles(dir, PHONEME_EXT.upper())

        for file in files:

            label = str.format("\"*\{0}{1}\"", file.rstrip(PHONEME_EXT.upper()), LAB_EXT)

            phn = open(dir + file, 'r+')

            mlf = open(MLFFile, 'a+')

            mlf.write(label + "\n")

            for line in phn:
                mlf.write(line)

            mlf.write(".\n")

            phn.close()
            mlf.close()




""" Generate the HMM definitions """
def generateHMMDefs(ext):
    ext = ext.lstrip('.').upper()
    trainingInformationDir = str.format("{0}{1}{2}", TRAINING_DIR, "Training", SEPARATOR)

    hmmDefs = str.format("{0}{1}{2}hmm0{2}HMMDef", HMM_DIR, ext, SEPARATOR)
    proto = str.format("{0}{1}{2}hmm0{2}{1}Proto", HMM_DIR, ext, SEPARATOR) # TODO: Edit proto files of each ext

    phn = open(PHONE_LOC, 'r')
    hmm = open(hmmDefs, 'w')

    for line in phn:
        hmm.write(str.format("~h \"{0}\"\n", line.strip("\n")))

        if line.lower() == SILENCE_PHN:
            hmm.write("\n")

        protoFile = open(proto, 'r')
        lineCount = 0

        for protoLine in protoFile:

            if lineCount > 3:
                hmm.write(protoLine)

            lineCount += 1

        hmm.write("\n")

        protoFile.close()

    phn.close()
    hmm.close()


""" Generate the macro files """
def generateMacros(ext):
    ext = ext.lstrip('.').upper()

    macros = str.format("{0}{1}{2}hmm0{2}{1}Macros", HMM_DIR, ext, SEPARATOR)
    proto = str.format("{0}{1}{2}hmm0{2}{1}Proto", HMM_DIR, ext, SEPARATOR)
    vFloor = str.format("{0}{1}{2}hmm0{2}vFloors", HMM_DIR, ext, SEPARATOR)

    macroFile = open(macros, 'w')
    headerFile = open(proto, 'r')

    lineCount = 0
    for line in headerFile:
        macroFile.write(line)
        lineCount += 1
        if lineCount >= 3:
            break

    headerFile.close()

    vFloorFile = open(vFloor, 'r')

    for line in vFloorFile:
        macroFile.write(line)

    vFloorFile.close()

    macroFile.close()




command = input("(I)nitiatise, (T)rain, (E)valuate or (Q)uit: ").upper()

while (not command.startswith("Q")):
    if (command.startswith("I")):
        # Generate the wav -> MFC script
        print("Generating the wav -> MFC conversion script")
        generateConversionList()
        print("Completed")

        sleep(SLEEP_S)

        # Perform the wav -> MFC conversion
        convertFile = str.format("{0}{1}{2}", SCRIPT_DIR, "WAV_MFC_Conversion_List", SCRIPT_EXT)
        conversionCommand = str.format("HCopy -T 1 -C {0} -S {1}", MFC_CONVERT_CONFIG, convertFile)
        print("Performing wav -> MFC conversion")
        #os.system(conversionCommand)
        print("Completed")

        sleep(SLEEP_S)

        # Generate the classifier lists
        print("Generating lists for each classifier")
        generateClassifierLists()
        print("Completed")

        sleep(SLEEP_S)

        # Generate MLF
        print("Generating MLF")
        generateMLF()
        print("Completed")

        sleep(SLEEP_S)

        # Generate first pass HMM's
        for ext in ['.mfc']:    #TODO: Update so it can do multiple classifier configs
            ext = ext.lstrip('.').upper()

            script = str.format("{0}{1}_Training_List.scp", SCRIPT_DIR, ext)
            outputFolder = str.format("{0}{1}{2}hmm0", HMM_DIR, ext, SEPARATOR)
            hmmCommand = str.format("HCompV -T 1 -C {0} -f 0.01 -m -S {1} -M {2} {3}",
                                    HCOMPV_CONFIG.replace("||", ext),
                                    script,
                                    outputFolder,
                                    PROTO_CONFIG)
            print(str.format("Performing {0} HMM initialisation", ext))
            os.system(hmmCommand)
            print("Completed")

            sleep(SLEEP_S)

            # Generate hmmdef and macro files
            print("Generating HMM Definitions")
            generateHMMDefs(ext)
            print("Completed")
            print("Generating Macros")
            generateMacros(ext)
            print("Completed")

            sleep(SLEEP_S)

        # Check if .phn have been converted to .lab files
        print("Checking if .phn -> .lab conversion has occurred")
        createLabFiles()
        print("Completed")

        sleep(SLEEP_S)

    elif (command.startswith("T")):
        for ext in [".mfc"]:                # TODO: Handle all classifiers
            ext = ext.lstrip('.').upper()
            for i in range(3):

                print(str.format("Performing Re-Estimation {0} for the {1} classifier", i+1, ext))

                macros = str.format("{0}{1}{2}hmm{3}{2}{1}Macros", HMM_DIR, ext, SEPARATOR, i)
                hmmDefs = str.format("{0}{1}{2}hmm{3}{2}HMMDef", HMM_DIR, ext, SEPARATOR, i)
                output = str.format("{0}{1}{2}hmm{3}", HMM_DIR, ext, SEPARATOR, i+1)

                command = str.format("HERest -C {0} -I {1} -t 250.0 150.0 1000.0 -S {2} -H {3} -H {4} -M {5} {6}",
                                     HCOMPV_CONFIG.replace("||", ext),
                                     SCRIPT_DIR + "phones0.mlf",
                                     SCRIPT_DIR + ext + "_Training_List.scp",
                                     macros,
                                     hmmDefs,
                                     output,
                                     PHONE_LOC
                                     )

                print(command)
                pass
                os.system(command)

                print("Completed")

                sleep(SLEEP_S)


    elif (command.startswith("E")):
        buildFileStructure()
    else:
        print("Invalid option.")


    command = input("(I)nitiatise, (T)rain, (E)valuate or (Q)uit: ").upper()
