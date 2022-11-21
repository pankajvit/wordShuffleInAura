@isTest
public class AssignPodTest {
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
        	for(Integer i=0;i<1;i++){
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
        	insert metaData;
        	insert loanApp;
    }
	@isTest
    public static void stampPodToDTWTTest(){
        List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
        Map<String,Set<Pod__c>> locationPods = new Map<String,Set<Pod__c>>(); 
		locationPods = CreateDTWT.getLocationPods();
        List<Loan_Application__c> loanApplications = CreateDTWT.checkPodForLocation(locationPods,loanApps);
        //System.debug(loanApps);
        //System.debug(loanApplications);
        //System.debug(locationPods);
        
    	//compare with stage substage of the metadata
        //List<Loan_Application__c> finallapplications = CreateDTWT.checkMetadataAvailbility(loanApplications);
        //Check if dtwt exists
		//CreateDTWT.removingExistingDTWT(finallapplications);
        //System.debug(finallapplications);
            	
    	//create dtwt record.
    	List<DTWT__c> dtwtList = new List<DTWT__c>(); 
        List<Pod__c> podid = [select id from Pod__c];
    	//dtwtList = CreateDTWT.createRecord(finallapplications,locationPods);
        AssignPod.stampPodToDTWT(dtwtList,locationPods);
        List<DTWT__c> createdDTWT = [SELECT Id, Name, Pod__c FROM DTWT__c];
        system.debug(createdDTWT.size());
        for(DTWT__c d : createdDTWT){
            system.debug(d);
        }
        
        System.assertEquals(createdDTWT[0].Pod__c, podid[0].Id, 'AssignPod is not working properly');
    }
}