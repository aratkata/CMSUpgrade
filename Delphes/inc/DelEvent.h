/*
 * =====================================================================================
 *
 *       Filename:  DelEvent.h
 *
 *    Description:  A dummy class to hold the Delphes events, so that I can
 *    play all the tricks on it
 *
 *        Version:  1.0
 *        Created:  06/03/2013 11:12:10 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Zhenbin Wu (benwu), benwu@fnal.gov
 *        Company:  Baylor University, CMS@FNAL
 *
 * =====================================================================================
 */

#ifndef  __DELEVENT_INC__
#define  __DELEVENT_INC__


//#include <forward_list>
#include <list>
#include <map>
#include <iostream>
#include <set>
#include "TClonesArray.h"
#include "classes/DelphesClasses.h"
#include "DelAna.h"
/*
 * =====================================================================================
 *        Class:  DelEvent
 *  Description:  A class to hold the loaded Del event
 * =====================================================================================
 */
class DelEvent
{
  public:

    /* ====================  LIFECYCLE     =============================== */
    DelEvent (double Eta, double Pt);   /* constructor      */
    DelEvent ( const DelEvent &other ); /* copy constructor */
    virtual ~DelEvent ();                       /* destructor       */


    /* ====================  MUTATORS      ======================================= */

    /* ====================  OPERATORS     ======================================= */

    DelEvent& operator = ( const DelEvent& other ); /* assignment operator */


    /* ====================  ACCESSORS     ======================================= */
    // Public access to load the event, virtual for Zll fakign zvv
    virtual bool LoadEvent(TClonesArray *branchEvent,TClonesArray *branchJet, 
        TClonesArray *branchGenJet, TClonesArray *branchCAJet, TClonesArray *branchElectron, 
        TClonesArray *branchMuon, TClonesArray *branchPhoton, TClonesArray *branchMet, 
        TClonesArray *branchHt, TClonesArray *branchParticle);

    // To store the event information 
    // only use common infor from 307 and 309
    std::vector<LHEFEvent> vEvent;
    std::vector<GenParticle> vGenParticle;
    std::vector<Photon> vPhoton;
    std::vector<Electron> vElectron;
    std::vector<Muon> vMuon;
    std::vector<Jet> vJet, vGenJet, vCAJet;
    std::vector<MissingET> vMissingET;
    double DelHT;
    TVector2 PUCorMet;
    TLorentzVector MHT;
    double HT;
    //Flags for the selection on the event
    double JetEtaCut;
    double JetPtCut;

    // Virtual preselected for the signal sample, which is generated with the
    // preselection
    int CleanEvent();
    virtual bool PreSelected();
    virtual bool CalPUCorMet();

  protected:
    /* ====================  DATA MEMBERS  ======================================= */
    int LoadEvent(TClonesArray *branchEvent);
    int LoadGenParticle(TClonesArray *branchGenParticle);
    int LoadRawMet(TClonesArray *branchMet);
    int LoadPhoton(TClonesArray *branchPhoton);
    int LoadMuon(TClonesArray *branchMuon);
    int LoadElectron(TClonesArray *branchElectron);
    Jet* JetCor(Jet jet, TLorentzVector CorVet);
    bool JetSel(Jet j);
    int LoadJet(TClonesArray *branchJet);
    int LoadGenJet(TClonesArray *branchJet);
    int LoadCAJet(TClonesArray* branchCAJet);
    int LoadScalarHT(TClonesArray *branchHt);
    // GenParticle level preselection, which rejects almost all the events
    double GenMet();
    bool GenPreSelected();
    bool CorLepJet(int idx, Jet *jet);


    // The index of jets to be vetoed by the different function
    // Using set for the unique elements
    std::set<int>  RMjet;
    // A mapping to correct the jet energy
    std::map<int, TLorentzVector> CRJet;

    /*---------------------------------------------------------------------------
     *  Virtual functions
     *--------------------------------------------------------------------------*/
    // Public access to check the flag of selection in the event, usually
    // separated out for different DelCut in the filling
    virtual bool CheckFlag(std::string flag);

  private:
    /* ====================  DATA MEMBERS  ======================================= */
    
    friend class DelAna;

}; /* -----  end of class DelEvent  ----- */


#endif   /* ----- #ifndef __DELEVENT_INC__  ----- */
