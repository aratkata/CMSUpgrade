
/** \class TauTagging
 *
 *  Determines origin of jet,
 *  applies b-tagging efficiency (miss identification rate) formulas
 *  and sets b-tagging flags
 *
 *  $Date: 2013-03-21 00:23:25 +0100 (Thu, 21 Mar 2013) $
 *  $Revision: 1065 $
 *
 *
 *  \author P. Demin - UCL, Louvain-la-Neuve
 *
 */

#include "modules/TauTagging.h"

#include "classes/DelphesClasses.h"
#include "classes/DelphesFactory.h"
#include "classes/DelphesFormula.h"

#include "ExRootAnalysis/ExRootResult.h"
#include "ExRootAnalysis/ExRootFilter.h"
#include "ExRootAnalysis/ExRootClassifier.h"

#include "TMath.h"
#include "TString.h"
#include "TFormula.h"
#include "TRandom3.h"
#include "TObjArray.h"
#include "TDatabasePDG.h"
#include "TLorentzVector.h"

#include <algorithm>
#include <stdexcept>
#include <iostream>
#include <sstream>

using namespace std;

//------------------------------------------------------------------------------

class TauTaggingPartonClassifier : public ExRootClassifier
{
public:

  TauTaggingPartonClassifier(const TObjArray *array);

  Int_t GetCategory(TObject *object);

  Double_t fEtaMax, fPTMin;

  const TObjArray *fParticleInputArray;
};

//------------------------------------------------------------------------------
TauTaggingPartonClassifier::TauTaggingPartonClassifier(const TObjArray *array) :
  fParticleInputArray(array)
{
}

//------------------------------------------------------------------------------

Int_t TauTaggingPartonClassifier::GetCategory(TObject *object)
{
  Candidate *tau = static_cast<Candidate *>(object);
  Candidate *daughter = 0;
  const TLorentzVector &momentum = tau->Momentum;
  Int_t pdgCode, i;

  pdgCode = TMath::Abs(tau->PID);
  if(pdgCode != 15) return -1;

  if(momentum.Pt() <= fPTMin || TMath::Abs(momentum.Eta()) > fEtaMax) return -1;

  if(tau->D1 < 0) return -1;

  for(i = tau->D1; i <= tau->D2; ++i)
  {
    daughter = static_cast<Candidate *>(fParticleInputArray->At(i));
    pdgCode = TMath::Abs(daughter->PID);
    if(pdgCode == 11 || pdgCode == 13 || pdgCode == 15 || pdgCode == 24) return -1;
  }

  return 0;
}

//------------------------------------------------------------------------------

TauTagging::TauTagging() :
  fClassifier(0), fFilter(0),
  fItPartonInputArray(0), fItJetInputArray(0)
{
}

//------------------------------------------------------------------------------

TauTagging::~TauTagging()
{
}

//------------------------------------------------------------------------------

void TauTagging::Init()
{
  map< Int_t, DelphesFormula * >::iterator itEfficiencyMap;
  ExRootConfParam param;
  DelphesFormula *formula;
  Int_t i, size;

  fDeltaR = GetDouble("DeltaR", 0.5);

  // read efficiency formulas
  param = GetParam("EfficiencyFormula");
  size = param.GetSize();

  fEfficiencyMap.clear();
  for(i = 0; i < size/2; ++i)
  {
    formula = new DelphesFormula;
    formula->Compile(param[i*2 + 1].GetString());

    fEfficiencyMap[param[i*2].GetInt()] = formula;
  }

  // set default efficiency formula
  itEfficiencyMap = fEfficiencyMap.find(0);
  if(itEfficiencyMap == fEfficiencyMap.end())
  {
    formula = new DelphesFormula;
    formula->Compile("0.0");

    fEfficiencyMap[0] = formula;
  }

  // import input array(s)

  fParticleInputArray = ImportArray(GetString("ParticleInputArray", "Delphes/allParticles"));

  fClassifier = new TauTaggingPartonClassifier(fParticleInputArray);
  fClassifier->fPTMin = GetDouble("TauPTMin", 1.0);
  fClassifier->fEtaMax = GetDouble("TauEtaMax", 2.5);

  fPartonInputArray = ImportArray(GetString("PartonInputArray", "Delphes/partons"));
  fItPartonInputArray = fPartonInputArray->MakeIterator();

  fFilter = new ExRootFilter(fPartonInputArray);

  fJetInputArray = ImportArray(GetString("JetInputArray", "FastJetFinder/jets"));
  fItJetInputArray = fJetInputArray->MakeIterator();
}

//------------------------------------------------------------------------------

void TauTagging::Finish()
{
  map< Int_t, DelphesFormula * >::iterator itEfficiencyMap;
  DelphesFormula *formula;

  if(fFilter) delete fFilter;
  if(fClassifier) delete fClassifier;
  if(fItJetInputArray) delete fItJetInputArray;
  if(fItPartonInputArray) delete fItPartonInputArray;

  for(itEfficiencyMap = fEfficiencyMap.begin(); itEfficiencyMap != fEfficiencyMap.end(); ++itEfficiencyMap)
  {
    formula = itEfficiencyMap->second;
    if(formula) delete formula;
  }
}

//------------------------------------------------------------------------------

void TauTagging::Process()
{
  Candidate *jet, *tau;
  Double_t pt, eta, phi;
  TObjArray *tauArray;
  map< Int_t, DelphesFormula * >::iterator itEfficiencyMap;
  DelphesFormula *formula;
  Int_t pdgCode, charge;

  // select taus
  fFilter->Reset();
  tauArray = fFilter->GetSubArray(fClassifier, 0);

  if(tauArray == 0) return;

  TIter itTauArray(tauArray);

  // loop over all input jets
  fItJetInputArray->Reset();
  while((jet = static_cast<Candidate *>(fItJetInputArray->Next())))
  {
    const TLorentzVector &jetMomentum = jet->Momentum;
    pdgCode = 0;
    charge = gRandom->Uniform() > 0.5 ? 1 : -1;
    eta = jetMomentum.Eta();
    phi = jetMomentum.Phi();
    pt = jetMomentum.Pt();

    // loop over all input taus
    itTauArray.Reset();
    while((tau = static_cast<Candidate *>(itTauArray.Next())))
    {
      if(jetMomentum.DeltaR(tau->Momentum) <= fDeltaR)
      {
        pdgCode = 15;
        charge = tau->Charge;
      }
    }
    // find an efficency formula
    itEfficiencyMap = fEfficiencyMap.find(pdgCode);
    if(itEfficiencyMap == fEfficiencyMap.end())
    {
      itEfficiencyMap = fEfficiencyMap.find(0);
    }
    formula = itEfficiencyMap->second;

    // apply an efficency formula
    jet->TauTag = gRandom->Uniform() <= formula->Eval(pt, eta);
    // set tau charge
    jet->Charge = charge;
  }
}

//------------------------------------------------------------------------------
