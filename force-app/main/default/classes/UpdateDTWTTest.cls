@isTest
public class UpdateDTWTTest {
    @testsetup static void initData(){
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
     	User usr = new User(LastName = 'LIVESTON',
                           FirstName='JASON',
                           Alias = 'jliv',
                           Email = 'pankajvitmca@gmail.com',
                           Username = 'test111@psl.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        	insert usr;
        	//creation of Hub
        	Hub__c hub = new Hub__c(Location__c='Mumbai', Hub_Manager__c=usr.id, Type__c='Virtual');
        	insert hub;
        	//creation of Pod
            List<string> locationForPod = new  List<string>{'Mumbai','Pune','Nagpur','DELHI','AGRA','AJMER','ANAND','BARODA','BHEL','BHOPAL'};
            List<Pod__c> Pods = new List<Pod__c>();
        	//if you want to increase pod size then use "i<10"
        	for(integer i=0;i<1;i++){
        		Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai');   
                Pods.add(pod);
        	}
        	insert Pods;
        	// creation of Stage-Substage Meta data & dummy loan application
        	List<DigiTwin_Stage_Sub_Stage_Master__c> metaData = new List<DigiTwin_Stage_Sub_Stage_Master__c>();
        	List<Loan_Application__c> loanApp = new List<Loan_Application__c>();
        	List<string> stage = new List<string>{'Data Verification','Underwriting','Reject','Verification'};
            List<string> subStage = new List<string>{'Data Verification Pending','Data Verification Unhold','Data Verification Hold','Underwriting Pending','Underwriting Hold','Underwriting Reject','Policy Reject','Credit Reject','Operation Reject','Verification Pending','Verification Hold','Submit to Finnone'};
            List<string> locationForLoanApp = new  List<string>{'Mumbai','Pune','Nagpur','DELHI','AGRA','AJMER','ANAND','BARODA','BHEL','BHOPAL'};
            Integer k=0;
        	//if you want to increase stage then use stage.size();
        	for(Integer i=0;i<stage.size();i++){
                 k=(i*2)+i;
                 //System.debug(k);
                 for(Integer j=k;j<(k+3);j++){
                     // random number generation code starts here
                     // uncomment below two line for get random number from locationForLoapApp list
                     	//Integer listSize = locationForLoanApp.size() - 1;
						//Integer randomNumber = Integer.valueof((Math.random() * listSize));
						//String randomString= availableValues[randomNumber];
                     // random number generation code ends here
                 	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c=stage[i], Sub_Stage__c=subStage[j], isActive__c=true, Business_unit__c='SEPL');
                    Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='SEPL', Location__c='Mumbai', Stage__c=stage[i], Sub_Stage__c=subStage[j]);
					//System.debug(metaDataCombination);
					System.debug(loanapplication);
                    metaData.add(metaDataCombination);
                    loanApp.add( loanapplication);
                 }
            }
        	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination1 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='CPA Login', Sub_Stage__c='', isActive__c=true, Business_unit__c='SEPL');
        	metaData.add(metaDataCombination1);
        	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination2 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='Maker', Sub_Stage__c='SBD Ops Maker Pending', isActive__c=true, Business_unit__c='SEPL');
        	metaData.add(metaDataCombination2);
        	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination3 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='Submitted to finnone', Sub_Stage__c='', isActive__c=true, Business_unit__c='SEPL');
        	metaData.add(metaDataCombination3);
        	insert metaData;
        	insert loanApp;
    }
	@isTest
    public static void updateDTWTfildsTest(){
        //first we create DTWT for all 3 loan application 
        List<Loan_Application__c> lapps = new List<Loan_Application__c>();
        lapps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        CreateDTWT.createdtwtrecord(lapps);
        
        
        // then we update the stage and substage of all 3 dummy loan application
        List<Loan_Application__c> loanAppRecord = new List<Loan_Application__c>();
        for(Loan_Application__c l : lapps){
            l.Stage__c='Data Verification';
            l.Sub_Stage__c='Data Verification Hold';
            loanAppRecord.add(l);
        }
        update loanAppRecord;
        
        //After the change of all loan application, we are passing the loan application
        //UpdateDTWT.updateDTWTfilds([select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c]);
        //updateDTWTfilds will change stage and substage of loan applications
        List<DTWT__c> changedDTWT = new List<DTWT__c>();
        changedDTWT = [select Id, Stage__c,subStage__c from DTWT__c];
        system.debug(changedDTWT);
        //now we are comparing that is new change reflecting in all DTWT fields.
        System.assertEquals('Data Verification', changedDTWT[0].Stage__c, 'updateDTWTfilds is not working');
    }
    @isTest
    public static void stageChangeTest1(){
    	List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        //CreateDTWT.createdtwtrecord(loanApps);
        List<DTWT__c> createdDTWT = new List<DTWT__c>();
        createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        System.debug(createdDTWT);
        createdDTWT[0].Stage__c = 'CPA Login';
        createdDTWT[0].subStage__c='';
        
        update createdDTWT;
        //createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        //System.debug(createdDTWT);
        Map<Id,DTWT__c> oldDtwts = new Map<Id,DTWT__c>();
        oldDtwts.put(createdDTWT[0].id,createdDTWT[0]);
        system.debug(oldDtwts);
        List<DTWT__c> newDtwts = new List<DTWT__c>();
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        newDtwts[0].Status__c = 'Completed';
        update newDtwts;
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        UpdateDTWT.stageChange(newDtwts, oldDtwts);
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        //System.debug(newDtwts[0].Stage__c);
        System.assertEquals('Underwriting',newDtwts[0].Stage__c,'stageChange is not working');
        System.assertEquals('Underwriting Pending', newDtwts[0].subStage__c,'stageChange is not working');
    }
    @isTest
    public static void stageChangeTest2(){
        List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        //CreateDTWT.createdtwtrecord(loanApps);
        List<DTWT__c> createdDTWT = new List<DTWT__c>();
        createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        System.debug(createdDTWT);
        createdDTWT[0].Stage__c = 'Underwriting';
        createdDTWT[0].subStage__c='Underwriting Approved';
        
        update createdDTWT;
        //createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        //System.debug(createdDTWT);
        Map<Id,DTWT__c> oldDtwts = new Map<Id,DTWT__c>();
        oldDtwts.put(createdDTWT[0].id,createdDTWT[0]);
        system.debug(oldDtwts);
        List<DTWT__c> newDtwts = new List<DTWT__c>();
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        newDtwts[0].Status__c = 'Completed';
        update newDtwts;
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        UpdateDTWT.stageChange(newDtwts, oldDtwts);
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        //System.debug(newDtwts[0].Stage__c);
        System.assertEquals('Maker',newDtwts[0].Stage__c,'stageChange is not working');
    }
    @isTest
    public static void stageChangeTest3(){
        List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        //CreateDTWT.createdtwtrecord(loanApps);
        List<DTWT__c> createdDTWT = new List<DTWT__c>();
        createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        System.debug(createdDTWT);
        createdDTWT[0].Stage__c = 'Maker';
        createdDTWT[0].subStage__c='';
        
        update createdDTWT;
        //createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        //System.debug(createdDTWT);
        Map<Id,DTWT__c> oldDtwts = new Map<Id,DTWT__c>();
        oldDtwts.put(createdDTWT[0].id,createdDTWT[0]);
        system.debug(oldDtwts);
        List<DTWT__c> newDtwts = new List<DTWT__c>();
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        newDtwts[0].Status__c = 'Completed';
        update newDtwts;
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        UpdateDTWT.stageChange(newDtwts, oldDtwts);
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        //System.debug(newDtwts[0].Stage__c);
        System.assertEquals('Checker',newDtwts[0].Stage__c,'stageChange is not working');
    }
    @isTest
    public static void stageChangeTest4(){
        List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        //CreateDTWT.createdtwtrecord(loanApps);
        List<DTWT__c> createdDTWT = new List<DTWT__c>();
        createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        System.debug(createdDTWT);
        createdDTWT[0].Stage__c = 'Checker';
        createdDTWT[0].subStage__c='';
        
        update createdDTWT;
        //createdDTWT = [select Id, Stage__c,subStage__c,	Status__c from DTWT__c LIMIT 1];
        //System.debug(createdDTWT);
        Map<Id,DTWT__c> oldDtwts = new Map<Id,DTWT__c>();
        oldDtwts.put(createdDTWT[0].id,createdDTWT[0]);
        system.debug(oldDtwts);
        List<DTWT__c> newDtwts = new List<DTWT__c>();
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        newDtwts[0].Status__c = 'Completed';
        update newDtwts;
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        UpdateDTWT.stageChange(newDtwts, oldDtwts);
        newDtwts = [select Id, Stage__c,subStage__c,Status__c from DTWT__c LIMIT 1];
        //System.debug(newDtwts[0].Stage__c);
        System.assertEquals('Submitted to finnone',newDtwts[0].Stage__c,'stageChange is not working');
    }
    
}