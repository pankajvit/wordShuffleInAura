@isTest
public class FileAllocationTest {
    @testsetup
    public static void initData(){
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
        	Pod__c pod = new Pod__c(Hub__c=hub.id, Champion_Product_1__c='BIL PL', 	Active_Product__c='Product', Product__c='SEPL', Locations__c='Mumbai');
        	insert pod;
        	Team__c team = new Team__c(Pod__c=pod.id);
        	insert team;
        	Loan_Application__c loanapplication = new Loan_Application__c(Business_unit__c='BIL PL', Location__c='Delhi', Stage__c='Underwriting', Sub_Stage__c='Underwriting Approved');
        	insert loanapplication;
        	DTWT__c dtwt = new DTWT__c(LoanApplicationId__c=loanapplication.id, Pod__c=pod.id, 	Stage__c='Underwriting', subStage__c='Underwriting Pending', Product__c='SEPL', Status__c='In Queue', Sequence__c=1);
    		insert dtwt;
        	Team_Member__c teamMember = new Team_Member__c(Name='ABC',Team__c=team.id,User__c=usr.id,Skillset__c='Underwriter', isOnline__c=true,Working__c='Monday;Tuesday;Wednesday;Thursday;Friday',Skill__c='Thin',isActive__c=true);
        	insert teamMember; 	
    }
    @isTest static void FileAllocationToTeamMemberTest(){
        List<Team_Member__c> tm = new List<Team_Member__c>();
        tm = [Select id, Name, Team__c, User__c, Skillset__c, isOnline__c, Working__c, Skill__c, isActive__c from Team_Member__c];
        List<DTWT__c> dtwt = [Select Stage__c, subStage__c, OwnerId from DTWT__c];
        FileAllocation.FileAllocationToTeamMember(tm);
        //System.assertEquals(tm.User__c, dtwt.OwnerId, 'FileAllocationToTeamMember is not working');
    }
}