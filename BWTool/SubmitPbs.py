#!/bin/env python
# Example PBS cluster job submission in Python

import os
from popen2 import popen2
import time
import glob


###############################
DelDir    = '/home/benwu/CMSUpgrade/Delphes'
DelExe    = 'DelFill'
Directory = 'TEST_5_30'
UserEMAIL = 'benwu@fnal.gov'
PileUps   = [
    'NoPileUp',
    #'50PileUp',
    #'140PileUp',
]
Process = [
    'TT_8TEV',
    #'ZJETS_8TEV_HT1',
    #'ZJETS_8TEV_HT2',
    #'ZJETS_8TEV_HT3',
    #'ZJETS_8TEV_HT4',
    #'W1Jet_8TEV',
    #'W2Jet_8TEV',
    #'W3Jet_8TEV',
    #'W4Jet_8TEV',
]

def QSUB(Outdir, Process):

    # Open a pipe to the qsub command.
    #output, input = popen2('echo')
    output, input = popen2('qsub')

    job_name = "%s_%s" % (Outdir, Process)

    walltime = "24:00:00"
    processors = "nodes=1:ppn=8"

    command1 = "./RunHT.csh %s %s" % (Process, Outdir)


    job_string = """#!/bin/tcsh
    #PBS -N %s
    #PBS -l walltime=%s
    #PBS -l %s
    #PBS -d %s
    #PBS -o ./%s/%s_stdout
    #PBS -e ./%s/%s_stderr
    date
    cd $PBS_O_WORKDIR/..
    source setup.sh
    cd $PBS_O_WORKDIR/%s
    %s
    date""" % (job_name, walltime, processors, DelDir,  Outdir, job_name, Outdir,
               job_name, Outdir, command1)

    # Send job_string to qsub
    input.write(job_string)
    input.close()

    # Print your job and the response to the screen
    print job_string
    print output.read()

    time.sleep(0.1)


def CheckQStat():
    while True:
        stat = os.popen("qstat -u benwu | wc").read()
        total = stat.split()[0]
        if total == '':
            break
        total = int(total)

        if total != 0 and total % 100 == 0:
            time.sleep(1800)
        else:
            time.sleep(30)

        if total < 300:
            break
        else:
            time.sleep(1800)

        print "Waiting for next submittion : %d" % total


def my_process():
    ## Some checking first
    my_CheckFile()

    ## Create the output directory
    outdir = DelDir + "/" + Directory
    try:
        os.mkdir(outdir)
    except OSError:
        pass

    ## Update RunHT.csh with DelDir and pileups
    RunHTFile = outdir + "/" + "RunHT.csh"
    PUtoRun = '"'
    for pu in PileUps:
        PUtoRun += "%s " % pu
    PUtoRun += '"'

    with open(RunHTFile, "wt") as outfile:
        for line in open("RunHT.csh", "r"):
            line = line.replace("PILEUPS", PUtoRun)
            line = line.replace("DELDIR", DelDir)
            line = line.replace("DELEXE", DelExe)
            outfile.write(line)

    ## Update condor files
    os.chdir(outdir)
    os.system("ln -s ../FileList .")

    for pro in Process:
        QSUB(Directory, pro)

def my_CheckFile():
    ## Check the Delphes Dir
    if os.path.isdir(DelDir):
        pass
    else:
        print "Please input the path to Delphes"
        quit()


    ## Check RunHT.csh file
    if os.path.isfile("RunHT.csh") and os.access("RunHT.csh", os.X_OK):
        #print "Found RunHT.csh"
        pass
    else:
        print "Please locate RunHT.csh"
        quit()

    ## Check DelFill to be execute
    DelFill = DelDir + "/" + DelExe
    if os.path.isfile(DelFill) and os.access(DelFill, os.X_OK):
        #print "Found DelFill"
        pass
    else:
        print "Please locate %s" % DelFill
        quit()

    ## Check HTadd
    if os.path.isfile("HTadd") and os.access("HTadd", os.X_OK):
        #print "Found HTadd"
        pass
    else:
        print "Please compile HTadd"
        return None

    ## Check Delphes_condor
    if os.path.isfile("Delphes_condor"):
        #print "Found HTadd"
        pass
    else:
        print "Please compile HTadd"
        quit()

if __name__ == "__main__":
    my_process()