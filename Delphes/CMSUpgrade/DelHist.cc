// ===========================================================================
// 
//       Filename:  DelHist.cc
// 
//    Description:  The main file to be called 
// 
//        Version:  1.0
//        Created:  05/19/2013 02:53:52 PM
//       Revision:  none
//       Compiler:  g++
// 
//         Author:  Zhenbin Wu (benwu), benwu@fnal.gov
//        Company:  Baylor University, CDF@FNAL
// 
// ===========================================================================

#include <cstdlib>
#include "DelFill.h"
#include <cmath>
#include <map>
#include <string>
#include <iostream>

using namespace std;
int Loop(TChain* chain, std::string Process, std::string PileUp );

const std::string Path = "dcache:/pnfs/cms/WAX/11/store/user/snowmass/Delphes-3.0.7/";
//const std::string Pileup = "NoPileUp";
//const std::string Pileup = "50PileUp";
//const std::string Pileup = "140PileUp";

int main ( int argc, char *argv[] )
{

  //if (argc != 3)
  //{
    //std::cout << "Please enter the pileup and process name to be run on ! " <<  std::endl;
    //return EXIT_FAILURE;
  //}

  std::string Pileup = "TEST";
  std::string Process = "ZJETS";

  //std::string Pileup = argv[1];
  //std::string Process = argv[2];
  const bool LoopCuts = false;

  std::cout<<"Running Process : \033[0;31m"<< Process<<"\033[0m with pileup : \033[1;36m"<< Pileup << "\033[0m"<< std::endl; 

  TString TreeList = Path + Pileup +"/"+Process+"/"+Process+"_"+Pileup+"_*.root";
  std::cout << "Files to be run on : " << TreeList  << std::endl;

  TChain chain("Delphes");
  //chain.Add("./TTBARW_13TEV_50PileUp_6351.root");
  chain.Add("./ZJETS_13TEV_NoPileUp_9850.root");
  //chain.Add(TreeList);
  if (chain.GetEntriesFast() == 0)
  {
    std::cout << "No files are attached! Exiting... " << std::endl;
    return EXIT_FAILURE;
  }

  if (LoopCuts)
  {
    Loop(&chain, Process, Pileup);
  } else {
    DPhes DP(&chain);
    DP.InitDelPhes(Process, Pileup);
    DP.ReadDelPhes();
    DP.SetCutBit("0"); //No Cut applied 
    //DP.SetCutBit("-1"); //All Cuts applied
    DP.BookHistogram();
    DP.Looping();
    DP.DrawHistogram();
  }

  return EXIT_SUCCESS;
}				// ----------  end of function main  ----------

int Loop(TChain* chain, std::string Process, std::string PileUp )
{
  typedef  std::map<std::string, std::string>  maps;
  //typedef  std::map<std::string, std::string>::iterator  maps_it;
  maps CutMap;
  CutMap["0"] = "NoCut";
  CutMap["0000000001"] = "CTVBF";
  CutMap["0000000011"] = "CTLepV";
  CutMap["0000000111"] = "CTMet50";
  CutMap["0000001111"] = "CTMjj";
  CutMap["0000011111"] = "CTMet200";
  CutMap["-1"] = "AllCut";

  for(maps::iterator c_it=CutMap.begin();
      c_it!=CutMap.end(); c_it++)
  {
    DPhes *DP = new DPhes(chain);
    TString PUCut = PileUp+"_"+c_it->second;
    DP->InitDelPhes(Process, PUCut.Data());
    DP->ReadDelPhes();
    DP->SetCutBit(c_it->first); //No Cut applied 
    DP->BookHistogram();
    DP->Looping();
    DP->DrawHistogram();
    delete DP;
  }
  return 1;
}

