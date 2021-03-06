#!/bin/bash

## This is the script I got from John Stupak for the Delphes HTbin sample

detector=$1

if [[ "$detector" == "Snowmass" ]]; then
  baseDir=/eos/uscms/store/user/snowmass/noreplica/HTBinned/Delphes-3.0.9.1/
fi

if [[ "$detector" == "PhaseI" ]]; then
  baseDir=/eos/cms/store/group/phys_higgs/upgrade/PhaseI/Configuration0/
fi

if [[ "$detector" == "PhaseII3" ]]; then
  baseDir=/eos/cms/store/group/phys_higgs/upgrade/PhaseII/Configuration3
fi

if [[ "$detector" == "PhaseII4" ]]; then
  baseDir=/eos/cms/store/group/phys_higgs/upgrade/PhaseII/Configuration4
fi

#/pnfs/cms/WAX/11/store/user/snowmass/HTBinned/Delphes-3.0.9.1
#baseDir=/pnfs/cms/WAX/11/store/user/snowmass/HTBinned/Delphes-3.0.9.1
#baseDir=/pnfs/cms/WAX/11/store/user/snowmass/HTBinned/Delphes-3.0.9.2

eoscms=''
#eoscms=/afs/cern.ch/project/eos/installation/0.2.31/bin/eos.select

mkdir -p ntuples

for PU in No 50 140
do
  for background in `${eoscms} ls ${baseDir}/${PU}PileUp`
  do
    for file in `${eoscms} ls ${baseDir}/${PU}PileUp/${background}/`
    do
      if [[   "$file" == *".root" ]]; then
        if [[ "$detector" == "Snowmass" ]]; then
          dcachePath=dcap://cmsgridftp.fnal.gov:24125/pnfs/fnal.gov/usr/`echo ${file} | cut -d '/' -f 3-`
        else
          dcachePath=root://eoscms.cern.ch/${baseDir}/${PU}PileUp/${background}/${file}
        fi
        dcachePath=${baseDir}/${PU}PileUp/${background}/${file}
        echo $dcachePath >> ntuples/${background}_${PU}PileUp.list
      fi
    done
  done
done

if [[ "$detector" == "Snowmass" ]]; then
  baseDir=/eos/uscms/store/user/benwu/Delphes-3.0.9/
fi

if [[ "$detector" == "PhaseI" ]]; then
  baseDir=/eos/uscms/store/user/benwu/PhaseI/
  #baseDir=/eos/cms/store/group/phys_higgs/upgrade/PhaseI/Configuration0/
fi

if [[ "$detector" == "PhaseII3" ]]; then
  baseDir=/eos/uscms/store/user/benwu/PhaseII3/
  #baseDir=/eos/cms/store/group/phys_higgs/upgrade/PhaseII/Configuration3
fi

if [[ "$detector" == "PhaseII4" ]]; then
  baseDir=/eos/uscms/store/user/benwu/PhaseII4/
  #baseDir=/eos/cms/store/group/phys_higgs/upgrade/PhaseII/Configuration4
fi

#----------------------------------------------------------------------------#
#                                 SUSY_SIGNAL                                #
#----------------------------------------------------------------------------#
for PU in No 50 140
do
  #for background in `${eoscms} ls ${baseDir}/SUSY_SIGNAL/${PU}PileUp`
  #for background in Wino100 Wino200 Wino500
  for background in Wino100_14TeV Wino200_14TeV Wino500_14TeV Sbottom15_14TeV Sbottom100_14TeV Sbottom150_14TeV Sbottom200_14TeV Sbottom50_14TeV Sbottom300_14TeV  Sbottom400_14TeV 
  do
    #for file in `${eoscms} ls ${baseDir}/SUSY_SIGNAL/${PU}PileUp/${background}/`
    for file in `${eoscms} ls ${baseDir}/${PU}PileUp/${background}/`
    do
      if [[   "$file" == *".root" ]]; then
        if [[ "$detector" == "Snowmass" ]]; then
          dcachePath=dcap://cmsgridftp.fnal.gov:24125/pnfs/fnal.gov/usr/`echo ${file} | cut -d '/' -f 3-`
        else
          dcachePath=root://eoscms.cern.ch/${baseDir}/SUSY_SIGNAL/${PU}PileUp/${background}/${file}
        fi
        dcachePath=${baseDir}/${PU}PileUp/${background}/${file}
        echo $dcachePath >> ntuples/${background}_${PU}PileUp.list
      fi
    done
  done
done

mkdir -p HTBin

### Move the file to my naming convention

for PU in No 50 140
do
  mv ntuples/Wino100_14TeV_${PU}PileUp.list                      HTBin/Wino100_14TeV_${PU}PileUp.list
  mv ntuples/Wino200_14TeV_${PU}PileUp.list                      HTBin/Wino200_14TeV_${PU}PileUp.list
  mv ntuples/Wino500_14TeV_${PU}PileUp.list                      HTBin/Wino500_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom15_14TeV_${PU}PileUp.list                    HTBin/Sbottom15_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom50_14TeV_${PU}PileUp.list                    HTBin/Sbottom50_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom100_14TeV_${PU}PileUp.list                    HTBin/Sbottom100_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom150_14TeV_${PU}PileUp.list                    HTBin/Sbottom150_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom200_14TeV_${PU}PileUp.list                    HTBin/Sbottom200_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom300_14TeV_${PU}PileUp.list                    HTBin/Sbottom300_14TeV_${PU}PileUp.list
  mv ntuples/Sbottom400_14TeV_${PU}PileUp.list                    HTBin/Sbottom400_14TeV_${PU}PileUp.list
  mv ntuples/Wino100_${PU}PileUp.list                            HTBin/Wino100_14TeV_${PU}PileUp.list
  mv ntuples/Wino200_${PU}PileUp.list                            HTBin/Wino200_14TeV_${PU}PileUp.list
  mv ntuples/Wino500_${PU}PileUp.list                            HTBin/Wino500_14TeV_${PU}PileUp.list
  mv ntuples/B-4p-0-1-v1510_14TEV_${PU}PileUp.list               HTBin/B_14TEV_HT1_${PU}PileUp.list
  mv ntuples/BB-4p-0-300-v1510_14TEV_${PU}PileUp.list            HTBin/BB_14TEV_HT1_${PU}PileUp.list
  mv ntuples/BB-4p-1300-2100-v1510_14TEV_${PU}PileUp.list        HTBin/BB_14TEV_HT4_${PU}PileUp.list
  mv ntuples/BB-4p-2100-100000-v1510_14TEV_${PU}PileUp.list      HTBin/BB_14TEV_HT5_${PU}PileUp.list
  mv ntuples/BB-4p-2100-100000_14TEV_${PU}PileUp.list            HTBin/BB_14TEV_HT5_${PU}PileUp.list
  mv ntuples/BB-4p-300-700-v1510_14TEV_${PU}PileUp.list          HTBin/BB_14TEV_HT2_${PU}PileUp.list
  mv ntuples/BB-4p-700-1300-v1510_14TEV_${PU}PileUp.list         HTBin/BB_14TEV_HT3_${PU}PileUp.list
  mv ntuples/BBB-4p-0-600-v1510_14TEV_${PU}PileUp.list           HTBin/BBB_14TEV_HT1_${PU}PileUp.list
  mv ntuples/BBB-4p-1300-100000-v1510_14TEV_${PU}PileUp.list     HTBin/BBB_14TEV_HT3_${PU}PileUp.list
  mv ntuples/BBB-4p-600-1300-v1510_14TEV_${PU}PileUp.list        HTBin/BBB_14TEV_HT2_${PU}PileUp.list
  mv ntuples/Bj-4p-0-300-v1510_14TEV_${PU}PileUp.list            HTBin/BJ_14TEV_HT1_${PU}PileUp.list
  mv ntuples/Bj-4p-1100-1800-v1510_14TEV_${PU}PileUp.list        HTBin/BJ_14TEV_HT4_${PU}PileUp.list
  mv ntuples/Bj-4p-1800-2700-v1510_14TEV_${PU}PileUp.list        HTBin/BJ_14TEV_HT5_${PU}PileUp.list
  mv ntuples/Bj-4p-2700-3700-v1510_14TEV_${PU}PileUp.list        HTBin/BJ_14TEV_HT6_${PU}PileUp.list
  mv ntuples/Bj-4p-300-600-v1510_14TEV_${PU}PileUp.list          HTBin/BJ_14TEV_HT2_${PU}PileUp.list
  mv ntuples/Bj-4p-3700-100000-v1510_14TEV_${PU}PileUp.list      HTBin/BJ_14TEV_HT7_${PU}PileUp.list
  mv ntuples/Bj-4p-600-1100-v1510_14TEV_${PU}PileUp.list         HTBin/BJ_14TEV_HT3_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-0-700-v1510_14TEV_${PU}PileUp.list       HTBin/BJJ_14TEV_HT1_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-1400-2300-v1510_14TEV_${PU}PileUp.list   HTBin/BJJ_14TEV_HT3_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-2300-3400-v1510_14TEV_${PU}PileUp.list   HTBin/BJJ_14TEV_HT4_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-2300-3400_14TEV_${PU}PileUp.list   HTBin/BJJ_14TEV_HT4_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-3400-100000-v1510_14TEV_${PU}PileUp.list HTBin/BJJ_14TEV_HT5_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-700-1400-v1510_14TEV_${PU}PileUp.list    HTBin/BJJ_14TEV_HT2_${PU}PileUp.list
  mv ntuples/H-4p-0-300-v1510_14TEV_${PU}PileUp.list             HTBin/H_14TEV_HT1_${PU}PileUp.list
  mv ntuples/H-4p-1500-100000-v1510_14TEV_${PU}PileUp.list       HTBin/H_14TEV_HT4_${PU}PileUp.list
  mv ntuples/H-4p-300-800-v1510_14TEV_${PU}PileUp.list           HTBin/H_14TEV_HT2_${PU}PileUp.list
  mv ntuples/H-4p-800-1500-v1510_14TEV_${PU}PileUp.list          HTBin/H_14TEV_HT3_${PU}PileUp.list
  mv ntuples/LL-4p-0-100-v1510_14TEV_${PU}PileUp.list            HTBin/LL_14TEV_HT1_${PU}PileUp.list
  mv ntuples/LL-4p-100-200-v1510_14TEV_${PU}PileUp.list          HTBin/LL_14TEV_HT2_${PU}PileUp.list
  mv ntuples/LL-4p-1400-100000-v1510_14TEV_${PU}PileUp.list      HTBin/LL_14TEV_HT6_${PU}PileUp.list
  mv ntuples/LL-4p-200-500-v1510_14TEV_${PU}PileUp.list          HTBin/LL_14TEV_HT3_${PU}PileUp.list
  mv ntuples/LL-4p-500-900-v1510_14TEV_${PU}PileUp.list          HTBin/LL_14TEV_HT4_${PU}PileUp.list
  mv ntuples/LL-4p-900-1400-v1510_14TEV_${PU}PileUp.list         HTBin/LL_14TEV_HT5_${PU}PileUp.list
  mv ntuples/LLB-4p-0-400-v1510_14TEV_${PU}PileUp.list           HTBin/LLB_14TEV_HT1_${PU}PileUp.list
  mv ntuples/LLB-4p-400-900-v1510_14TEV_${PU}PileUp.list         HTBin/LLB_14TEV_HT2_${PU}PileUp.list
  mv ntuples/LLB-4p-900-100000-v1510_14TEV_${PU}PileUp.list      HTBin/LLB_14TEV_HT3_${PU}PileUp.list
  mv ntuples/tB-4p-0-500-v1510_14TEV_${PU}PileUp.list            HTBin/TB_14TEV_HT1_${PU}PileUp.list
  mv ntuples/tB-4p-1500-2200-v1510_14TEV_${PU}PileUp.list        HTBin/TB_14TEV_HT4_${PU}PileUp.list
  mv ntuples/tB-4p-2200-100000-v1510_14TEV_${PU}PileUp.list      HTBin/TB_14TEV_HT5_${PU}PileUp.list
  mv ntuples/tB-4p-500-900-v1510_14TEV_${PU}PileUp.list          HTBin/TB_14TEV_HT2_${PU}PileUp.list
  mv ntuples/tB-4p-900-1500-v1510_14TEV_${PU}PileUp.list         HTBin/TB_14TEV_HT3_${PU}PileUp.list
  mv ntuples/tj-4p-0-500-v1510_14TEV_${PU}PileUp.list            HTBin/TJ_14TEV_HT1_${PU}PileUp.list
  mv ntuples/tj-4p-1000-1600-v1510_14TEV_${PU}PileUp.list        HTBin/TJ_14TEV_HT3_${PU}PileUp.list
  mv ntuples/tj-4p-1600-2400-v1510_14TEV_${PU}PileUp.list        HTBin/TJ_14TEV_HT4_${PU}PileUp.list
  mv ntuples/tj-4p-2400-100000-v1510_14TEV_${PU}PileUp.list      HTBin/TJ_14TEV_HT5_${PU}PileUp.list
  mv ntuples/tj-4p-500-1000-v1510_14TEV_${PU}PileUp.list         HTBin/TJ_14TEV_HT2_${PU}PileUp.list
  mv ntuples/tt-4p-0-600-v1510_14TEV_${PU}PileUp.list            HTBin/TT_14TEV_HT1_${PU}PileUp.list
  mv ntuples/tt-4p-1100-1700-v1510_14TEV_${PU}PileUp.list        HTBin/TT_14TEV_HT3_${PU}PileUp.list
  mv ntuples/tt-4p-1700-2500-v1510_14TEV_${PU}PileUp.list        HTBin/TT_14TEV_HT4_${PU}PileUp.list
  mv ntuples/tt-4p-2500-100000-v1510_14TEV_${PU}PileUp.list      HTBin/TT_14TEV_HT5_${PU}PileUp.list
  mv ntuples/tt-4p-600-1100-v1510_14TEV_${PU}PileUp.list         HTBin/TT_14TEV_HT2_${PU}PileUp.list
  mv ntuples/tB-4p-0-900-v1510_14TEV_${PU}PileUp.list            HTBin/TTB_14TEV_HT1_${PU}PileUp.list
  mv ntuples/tB-4p-1600-2500-v1510_14TEV_${PU}PileUp.list        HTBin/TTB_14TEV_HT3_${PU}PileUp.list
  mv ntuples/tB-4p-2500-100000-v1510_14TEV_${PU}PileUp.list      HTBin/TTB_14TEV_HT4_${PU}PileUp.list
  mv ntuples/tB-4p-900-1600-v1510_14TEV_${PU}PileUp.list         HTBin/TTB_14TEV_HT2_${PU}PileUp.list

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 33TEV ~~~~~
  mv ntuples/B-4p-0-1_33TEV_${PU}PileUp.list                     HTBin/B_33TEV_HT1_${PU}PileUp.list
  mv ntuples/Bj-4p-0-400_33TEV_${PU}PileUp.list                  HTBin/BJ_33TEV_HT1_${PU}PileUp.list
  mv ntuples/Bj-4p-400-1000_33TEV_${PU}PileUp.list               HTBin/BJ_33TEV_HT2_${PU}PileUp.list
  mv ntuples/Bj-4p-1000-1800_33TEV_${PU}PileUp.list              HTBin/BJ_33TEV_HT3_${PU}PileUp.list
  mv ntuples/Bj-4p-1800-3000_33TEV_${PU}PileUp.list              HTBin/BJ_33TEV_HT4_${PU}PileUp.list
  mv ntuples/Bj-4p-3000-4600_33TEV_${PU}PileUp.list              HTBin/BJ_33TEV_HT5_${PU}PileUp.list
  mv ntuples/Bj-4p-4600-6600_33TEV_${PU}PileUp.list              HTBin/BJ_33TEV_HT6_${PU}PileUp.list
  mv ntuples/Bj-4p-6600-100000_33TEV_${PU}PileUp.list            HTBin/BJ_33TEV_HT7_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-0-800_33TEV_${PU}PileUp.list             HTBin/BJJ_33TEV_HT1_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-1600-3000_33TEV_${PU}PileUp.list         HTBin/BJJ_33TEV_HT2_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-3000-4800_33TEV_${PU}PileUp.list         HTBin/BJJ_33TEV_HT3_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-4800-100000_33TEV_${PU}PileUp.list       HTBin/BJJ_33TEV_HT4_${PU}PileUp.list
  mv ntuples/Bjj-vbf-4p-800-1600_33TEV_${PU}PileUp.list          HTBin/BJJ_33TEV_HT5_${PU}PileUp.list
  mv ntuples/BB-4p-0-400_33TEV_${PU}PileUp.list                  HTBin/BB_33TEV_HT1_${PU}PileUp.list
  mv ntuples/BB-4p-400-1000_33TEV_${PU}PileUp.list               HTBin/BB_33TEV_HT2_${PU}PileUp.list
  mv ntuples/BB-4p-1000-2000_33TEV_${PU}PileUp.list              HTBin/BB_33TEV_HT3_${PU}PileUp.list
  mv ntuples/BB-4p-2000-3400_33TEV_${PU}PileUp.list              HTBin/BB_33TEV_HT4_${PU}PileUp.list
  mv ntuples/BB-4p-3400-100000_33TEV_${PU}PileUp.list            HTBin/BB_33TEV_HT5_${PU}PileUp.list
  mv ntuples/BBB-4p-0-800_33TEV_${PU}PileUp.list                 HTBin/BBB_33TEV_HT1_${PU}PileUp.list
  mv ntuples/BBB-4p-800-2000_33TEV_${PU}PileUp.list              HTBin/BBB_33TEV_HT2_${PU}PileUp.list
  mv ntuples/BBB-4p-2000-3600_33TEV_${PU}PileUp.list             HTBin/BBB_33TEV_HT3_${PU}PileUp.list
  mv ntuples/BBB-4p-3600-100000_33TEV_${PU}PileUp.list           HTBin/BBB_33TEV_HT4_${PU}PileUp.list
  mv ntuples/H-4p-0-400_33TEV_${PU}PileUp.list                   HTBin/H_33TEV_HT1_${PU}PileUp.list
  mv ntuples/H-4p-400-1200_33TEV_${PU}PileUp.list                HTBin/H_33TEV_HT2_${PU}PileUp.list
  mv ntuples/H-4p-1200-2400_33TEV_${PU}PileUp.list               HTBin/H_33TEV_HT3_${PU}PileUp.list
  mv ntuples/H-4p-2400-4200_33TEV_${PU}PileUp.list               HTBin/H_33TEV_HT4_${PU}PileUp.list
  mv ntuples/H-4p-4200-100000_33TEV_${PU}PileUp.list             HTBin/H_33TEV_HT5_${PU}PileUp.list
  mv ntuples/LL-4p-0-200_33TEV_${PU}PileUp.list                  HTBin/LL_33TEV_HT1_${PU}PileUp.list
  mv ntuples/LL-4p-200-600_33TEV_${PU}PileUp.list                HTBin/LL_33TEV_HT2_${PU}PileUp.list
  mv ntuples/LL-4p-600-1200_33TEV_${PU}PileUp.list               HTBin/LL_33TEV_HT3_${PU}PileUp.list
  mv ntuples/LL-4p-1200-1800_33TEV_${PU}PileUp.list              HTBin/LL_33TEV_HT4_${PU}PileUp.list
  mv ntuples/LL-4p-1800-100000_33TEV_${PU}PileUp.list            HTBin/LL_33TEV_HT5_${PU}PileUp.list
  mv ntuples/LLB-4p-0-800_33TEV_${PU}PileUp.list                 HTBin/LLB_33TEV_HT1_${PU}PileUp.list
  mv ntuples/LLB-4p-800-2000_33TEV_${PU}PileUp.list              HTBin/LLB_33TEV_HT2_${PU}PileUp.list
  mv ntuples/LLB-4p-2000-100000_33TEV_${PU}PileUp.list           HTBin/LLB_33TEV_HT3_${PU}PileUp.list
  mv ntuples/tB-4p-0-600_33TEV_${PU}PileUp.list                  HTBin/TB_33TEV_HT1_${PU}PileUp.list
  mv ntuples/tB-4p-600-1200_33TEV_${PU}PileUp.list               HTBin/TB_33TEV_HT2_${PU}PileUp.list
  mv ntuples/tB-4p-1200-2000_33TEV_${PU}PileUp.list              HTBin/TB_33TEV_HT3_${PU}PileUp.list
  mv ntuples/tB-4p-2000-3200_33TEV_${PU}PileUp.list              HTBin/TB_33TEV_HT4_${PU}PileUp.list
  mv ntuples/tB-4p-3200-100000_33TEV_${PU}PileUp.list            HTBin/TB_33TEV_HT5_${PU}PileUp.list
  mv ntuples/tj-4p-0-600_33TEV_${PU}PileUp.list                  HTBin/TJ_33TEV_HT1_${PU}PileUp.list
  mv ntuples/tj-4p-600-1200_33TEV_${PU}PileUp.list               HTBin/TJ_33TEV_HT2_${PU}PileUp.list
  mv ntuples/tj-4p-1200-2200_33TEV_${PU}PileUp.list              HTBin/TJ_33TEV_HT3_${PU}PileUp.list
  mv ntuples/tj-4p-2200-3600_33TEV_${PU}PileUp.list              HTBin/TJ_33TEV_HT4_${PU}PileUp.list
  mv ntuples/tj-4p-3600-100000_33TEV_${PU}PileUp.list            HTBin/TJ_33TEV_HT5_${PU}PileUp.list
  mv ntuples/tt-4p-0-600_33TEV_${PU}PileUp.list                  HTBin/TT_33TEV_HT1_${PU}PileUp.list
  mv ntuples/tt-4p-600-1200_33TEV_${PU}PileUp.list               HTBin/TT_33TEV_HT2_${PU}PileUp.list
  mv ntuples/tt-4p-1200-2000_33TEV_${PU}PileUp.list              HTBin/TT_33TEV_HT3_${PU}PileUp.list
  mv ntuples/tt-4p-2000-3200_33TEV_${PU}PileUp.list              HTBin/TT_33TEV_HT4_${PU}PileUp.list
  mv ntuples/tt-4p-3200-4800_33TEV_${PU}PileUp.list              HTBin/TT_33TEV_HT5_${PU}PileUp.list
  mv ntuples/tt-4p-4800-100000_33TEV_${PU}PileUp.list            HTBin/TT_33TEV_HT6_${PU}PileUp.list
done

mv ntuples HTBin
mv HTBin/* $detector
