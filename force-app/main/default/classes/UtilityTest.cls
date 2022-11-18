@isTest
public class UtilityTest {
    
	@isTest
    public static void getPodsTest(){
        // Test setup for getPodsTest method starts here
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', 	Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai;Pune');
        	insert pod;
        // Test setup for getPodsTest method ends here
        List<Pod__c> totalPod = new List<Pod__c>();
        totalPod = Utility.getPods();
		System.assertEquals(totalPod[0].Product__c, 'SEPL', 'getPods method is not working');
    }
    @isTest
    public static void getMetaDataTest(){
        // Test setup for getMetaDataTest method starts here
    	List<DigiTwin_Stage_Sub_Stage_Master__c> metaData = new List<DigiTwin_Stage_Sub_Stage_Master__c>();   
    	DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination1 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='UNDERWRITING', Sub_Stage__c='UNDERWRITING HOLD', isActive__c=true, Business_unit__c='BIL PL');
        metaData.add(metaDataCombination1);
        DigiTwin_Stage_Sub_Stage_Master__c metaDataCombination2 = new DigiTwin_Stage_Sub_Stage_Master__c(Stage__c='UNDERWRITING',Sub_Stage__c='UNDERWRITING APPROVED',isActive__c=true,Business_unit__c='BIL PL');
        metaData.add(metaDataCombination2);
        insert metaData;
    	//  Test setup for getMetaDataTest method ends here
        List<DigiTwin_Stage_Sub_Stage_Master__c> metaDatarec = new List<DigiTwin_Stage_Sub_Stage_Master__c>();
        metaDatarec = Utility.getMetaData();
        System.assertEquals(2, metaDatarec.size(), 'metaData method is not working');
    }
    @isTest
    public static void getExistingDTWTTest(){
        //  Test setup for getExistingDTWTTest method starts here
        
        Id lids;
    	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        insert loanapplication;
        lids = loanapplication.id;
        DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=lids);
        insert digiTwinTicket;
    	//  Test setup for getExistingDTWTTest method ends here
        List<DTWT__c> getExistingDTWT = new List<DTWT__c>();
        //new Set<id>{'a085i000003uCtBAAU'}
        getExistingDTWT = Utility.getExistingDTWT(new Set<id>{lids});
        System.assertEquals(1, getExistingDTWT.size(), 'getExistingDTWT method is not working');
    }
    @isTest
    public static void getNextSequenceTest1() {
        //  Test setup for getExistingDTWTTest method starts here
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', 	Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai;Pune');
        	insert pod;
        Id lids;
    	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        insert loanapplication;
        lids = loanapplication.id;
        DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=lids,	Sequence__c=0, Pod__c=pod.id);
        insert digiTwinTicket;
    	//  Test setup for getExistingDTWTTest method ends here
    	List<DTWT__c> dtwts = [Select id from DTWT__c];
    	Integer seq;
        //seq = Utility.getNextSequence(pod.id);
        //System.assertEquals(0, seq, 'loan application sequence is not 0');
    }
    @isTest
    public static void getNextSequenceTest2() {
        //  Test setup for getExistingDTWTTest method starts here
        Id lids;
    	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        insert loanapplication;
        lids = loanapplication.id;
        DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=lids, Sequence__c=1);
        insert digiTwinTicket;
    	//  Test setup for getExistingDTWTTest method ends here
    	Integer seq;
        //seq = Utility.getNextSequence();
        //System.assertEquals(1, seq, 'loan application sequence is not 0');
    }
    @isTest
    public static void getIdVsPodTest(){
        // Test setup for getIdVsPodTest method starts here
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai;Pune');
        	insert pod;
        // Test setup for getIdVsPodTest method ends here
        List<Pod__c> podList = new List<Pod__c>();
    	podList = [select id,Name from Pod__c];
        //system.debug(podList);
        List<Id> ids = new List<Id>();
        for(Pod__c p : podList){
            ids.add(p.id);
        }
        Map<id,Pod__c> idVsPods = new Map<id,Pod__c>();
        idVsPods = Utility.getIdVsPod(ids);
		//Map<id,Pod__c> idVsPods = new Map<id,Pod__c>([select id,Name from Pod__c where id in : ids]);
        System.assertEquals(podList[0].id, idVsPods.get(podList[0].id).id, 'getIdVsPodTest is not working properly');
    }
    @isTest
    public static void getPodVsDTWTTest(){
        
    }
    @isTest 
    static void getNextStageSequenceTest1(){
        // Test setup for getIdVsPodTest method starts here
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', 	Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai;Pune');
        	insert pod;
        	Id lids;
    		Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	insert loanapplication;
        	lids = loanapplication.id;
        	DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=lids, Pod__c=pod.Id,Stage__c='Underwriting', subStage__c='Underwriting Approved', Sequence__c=0);
        	insert digiTwinTicket;
        // Test setup for getIdVsPodTest method ends here
        	Integer maxsequence = Utility.getNextStageSequence('Data Vertification','01I5i000000qFU3');
        	System.assertEquals(0, maxsequence, 'getNextStageSequence is not returning right value');
        	
    }
    @isTest 
    static void getNextStageSequenceTest2(){
        // Test setup for getIdVsPodTest method starts here
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', 	Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai;Pune');
        	insert pod;
        	Id lids;
    		Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	insert loanapplication;
        	lids = loanapplication.id;
        	DTWT__c digiTwinTicket = new DTWT__c(LoanApplicationId__c=lids, Pod__c=pod.Id, Stage__c='Underwriting', subStage__c='Underwriting Approved', Sequence__c=1);
        	insert digiTwinTicket;
        // Test setup for getIdVsPodTest method ends here
        List<DTWT__c> dtwts = [Select id from DTWT__c];
        //System.debug(dtwts[0].id);
        Integer maxsequence = Utility.getNextStageSequence('Underwriting',pod.Id);
        System.assertEquals(1, maxsequence, 'getNextStageSequence is not returning right value');
    }
    @isTest
    static void getTeamMembersByUserIdTest(){
        // Test data setup starts from here
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', 	Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai;Pune');
        	insert pod;
        	Team__c team = new Team__c(Pod__c=pod.id);
        	insert team;
        	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	insert loanapplication;
        	DTWT__c dtwt = new DTWT__c(LoanApplicationId__c=loanapplication.id, Pod__c=pod.id, 	Stage__c='Underwriting', subStage__c='Underwriting Pending', Product__c='SEPL', Status__c='In Queue', Sequence__c=1);
    		insert dtwt;
        	Team_Member__c teamMember = new Team_Member__c(Name='ABC',Team__c=team.id,User__c=usr.id,Skillset__c='Underwriter', isOnline__c=true,Working__c='Monday;Tuesday;Wednesday;Thursday;Friday',Skill__c='Thin',isActive__c=true);
        	insert teamMember;
        // Test data setup starts from here
        	List<Team_Member__c> tm = new List<Team_Member__c>();
       		List<User> users = new List<User>();
        	users = [SELECT Name, Id, Email FROM User];
        	List<Id> userId = new List<Id>();
        	for(User u : users) {
            	userId.add(u.id);
        	}
        	tm = Utility.getTeamMembersByUserId(userId);	
    }
}