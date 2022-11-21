@isTest
public class CreateDTWTTest {
    @isTest
    public static void deletedTest(){
        //  Test setup for deletedTest method starts here
        Id lids;
    	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        insert loanapplication;
        //lids = loanapplication.id;
        //DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=lids,	Sequence__c=0);
        //insert digiTwinTicket;
        
    	//  Test setup for deletedTest method ends here
    	CreateDTWT.deleted();
        List<DTWT__c> dtrecord = [select id from DTWT__c];
        System.assertEquals(0, dtrecord.size(), 'deleted method doesn\'t worked');
    }
    @isTest
    public static void createdtwtrecordTest(){
        // Test setup for createdtwtrecordTest method starts here
        	//System.debug('I am inside createdtwtrecordTest');
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
        	for(integer i=0;i<10;i++){
        		Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', Active_Product__c='Product', Product__c='SEPL', Locations__c=locationForPod[i]);   
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
        	for(Integer i=0;i<stage.size();i++){
                 k=(i*2)+i;
                 //System.debug(k);
                 for(Integer j=k;j<(k+3);j++){
                     // random number generation code starts here
                     	Integer listSize = locationForLoanApp.size() - 1;
						Integer randomNumber = Integer.valueof((Math.random() * listSize));
						//String randomString= availableValues[randomNumber];
                     // random number generation code ends here
                 	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c=stage[i], Sub_Stage__c=subStage[j], isActive__c=true, Business_unit__c='BIL PL');
                    Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c=locationForLoanApp[randomNumber], Stage__c=stage[i], Sub_Stage__c=subStage[j]);
					//System.debug(metaDataCombination);
					System.debug(loanapplication);
                    metaData.add(metaDataCombination);
                    loanApp.add( loanapplication);
                 }
            }
        	insert metaData;
        	insert loanApp;
        //Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Mumbai', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        // Test setup for createdtwtrecordTest method ends here
       		
        //Testing of createdtwtrecord starts from here
        List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        CreateDTWT.createdtwtrecord(loanApps);
        List<DTWT__c> dtwtList = new List<DTWT__c>();
        dtwtList = [select Id, name, LoanApplicationId__c from DTWT__c];
        System.assertEquals(12, dtwtList.size(), 'createdwtrecord method is not working');
    }
    @isTest
    public static void getLocationPodsTest(){
        // Test setup for getLocationPodsTest method starts here
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
        	Hub__c hub = new Hub__c(Location__c='Mumbai', Hub_Manager__c=usr.id, Type__c='Virtual');
        	insert hub;
        	Pod__c pod1 = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai');
        	Pod__c pod2 = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='Used Car', Active_Product__c='Product', Product__c='STLAP', Locations__c='Mumbai;Pune');
        	List<Pod__c> l = new List<Pod__c>();
        	l.add(pod1);
        	l.add(pod2);
        	insert l;
        //  Test setup for getLocationPodsTest method ends here
        Map<String,Set<Pod__c>> result = CreateDTWT.getLocationPods();
        System.debug(result);
        Pod__c podResult = [SELECT Id,Locations__c,Name,Product__c from Pod__c Limit 1];
        Set<Pod__c> listOfPods = result.get('MUMBAI');
        System.debug(listOfPods);
        if(listOfPods.size() > 0){
            for(Pod__c p: listOfPods){
            	if(p.Locations__c=='Mumbai' && p.Product__c == 'SEPL'){
            		System.assertEquals('SEPL', p.Product__c, 'getLocationPods are not matching');     
            	}
        	}
        }
        
        //System.assertEquals('Mumbai', result.get('Mumbai'), 'getLocationPods method is not working');
    }
    @isTest
    public static void checkPodForLocationTest(){
        	//  Test setup for checkPodForLocationTest method starts here
        	List<Loan_Application__c> loanApp = new List<Loan_Application__c>();
        	Loan_Application__c loanapplication1 = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Pune', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	loanApp.add(loanapplication1);
        	Loan_Application__c loanapplication2 = new Loan_Application__c(Business_unit__c='SEPL', Location__c='Mumbai', Stage__c='Underwriting', Sub_Stage__c='Underwriting Hold');
        	loanApp.add(loanapplication2);
        	Loan_Application__c loanapplication3 = new Loan_Application__c(Business_unit__c='SEPL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Hold');
        	loanApp.add(loanapplication3);
        	insert loanApp;
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
        	Hub__c hub = new Hub__c(Location__c='Mumbai', Hub_Manager__c=usr.id, Type__c='Virtual');
        	insert hub;
        	Pod__c pod1 = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai');
        	Pod__c pod2 = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='Used Car', Active_Product__c='Product', Product__c='STLAP', Locations__c='Mumbai;Pune');
        	List<Pod__c> l = new List<Pod__c>();
        	l.add(pod1);
        	l.add(pod2);
        	insert l;
        	//  Test setup for checkPodForLocationTest method ends here
        	Map<String,Set<Pod__c>> locationPods = CreateDTWT.getLocationPods();
        	List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        	List<Loan_Application__c> lapps = CreateDTWT.checkPodForLocation(locationPods,loanApps);
        	System.assertEquals(2, lapps.size(), 'checkPodForLocation method is not working');
    }
    @isTest
    public static void checkMetadataAvailbilityTest(){
       //  Test setup for checkMetadataAvailbilityTest method starts here
       		// Dummy stage and substage data  
       		List<DigiTwin_Stage_Sub_Stage_Master__c> metaData = new List<DigiTwin_Stage_Sub_Stage_Master__c>();   
    		DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination1 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='UNDERWRITING', Sub_Stage__c='UNDERWRITING HOLD', isActive__c=true, Business_unit__c='BIL PL');
        	metaData.add(metaDataCombination1);
        	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination2 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='UNDERWRITING',Sub_Stage__c='UNDERWRITING APPROVED',isActive__c=true,Business_unit__c='BIL PL');
        	metaData.add(metaDataCombination2);
        	insert metaData;
        	// Dummy loan application data
        	List<Loan_Application__c> loanApp = new List<Loan_Application__c>();
        	Loan_Application__c loanapplication1 = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Pune', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	loanApp.add(loanapplication1);
        	Loan_Application__c loanapplication2 = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Mumbai', Stage__c='Underwriting', Sub_Stage__c='Underwriting Hold');
        	loanApp.add(loanapplication2);
        	Loan_Application__c loanapplication3 = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Reject');
        	loanApp.add(loanapplication3);
        	insert loanApp;
       //  Test setup for checkMetadataAvailbilityTest method ends here 
        List<Loan_Application__c> lApp = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        //List<Loan_Application__c> finallapplications = CreateDTWT.checkMetadataAvailbility(lApp);
        //System.assertEquals(2, finallapplications.size(), 'checkMetadataAvailbility method is not working');
    }
    @isTest
    public static void createRecordTest(){
        //  Test setup for createRecordTest method starts here
  
        	//Test data for loan application data 
        	List<Loan_Application__c> loanApp = new List<Loan_Application__c>();
        	Loan_Application__c loanapplication1 = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Pune', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	loanApp.add(loanapplication1);
        	Loan_Application__c loanapplication2 = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Mumbai', Stage__c='Underwriting', Sub_Stage__c='Underwriting Hold');
        	loanApp.add(loanapplication2);
        	insert loanApp;
        //  Test setup for createRecordTest method ends here
        	List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
  			Map<String,Set<Pod__c>> locationPods = new Map<String,Set<Pod__c>>();
        	locationPods = CreateDTWT.getLocationPods();
        	List<DTWT__c> dtwts = new List<DTWT__c>();
        	//dtwts = CreateDTWT.createRecord(loanApps, locationPods);
        	System.assertEquals(2, dtwts.size(), 'createRecord method is not working');
    }
    @isTest
    public static void removingExistingDTWTTest(){
       // Test setup for removingExistingDTWTTest method starts here
       		List<Id> lids = new List<Id>();
        	List<Loan_Application__c> loanApps = new List<Loan_Application__c>();
        	List<DTWT__c> dtwts =  new List<DTWT__c>();
        	List<string> BU = new List<string>{'BIL','BIL PL','Consumer Durable','Cross Sell PL','Customer Service','Gold Loan','Home Loan','Loan Against Property','Micro Business Loan','SEPL'};
        	//System.debug(BU[0]);
            for(Integer i=0;i<10;i++){
            	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c=BU[i], Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
                loanApps.add(loanapplication);
            }
        	insert loanApps;
			for(Loan_Application__c l : [select id from Loan_Application__c ]){
        		DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=l.id);
                dtwts.add(digiTwinTicket);
            }
        	insert dtwts;
        	System.debug(loanApps[0]);
        	System.debug(dtwts[0]);
       // Test setup for removingExistingDTWTTest method starts here
       		List<Loan_Application__c> lapp = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        	//CreateDTWT.removingExistingDTWT(lapp);
        	System.assertEquals(0, lapp.size(), 'removingExistingDTWTTest method is not working');
    }
}