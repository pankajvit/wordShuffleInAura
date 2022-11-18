public class FirstClass {
    
    public static void firstMethod(){
        //System.debug('hello world');
        integer i = 5;
        long l = 4569874522l;
        double a = 2.3;
        decimal d = 32.564;
        d.round();
        boolean b = true;
        String s = 'ayush manker';
        Date dob = Date.newInstance(1999, 10, 29);
   		Time t = Time.newInstance(7, 30, 2, 100);
        DateTime dt = DateTime.newInstance(dob,t);
        Id idd = 'a005i000004Q942AAC';// id can be of 15 length or 18 lenght.
        blob blb = blob.valueOf('dsfsd4fd4ffdsf4'); //binary object, it is used to store binary data in apex
        //System.debug(blb.toString());
        //////////////////////////////////////////
        Account acc = new Account(name = 'Ayush');
        Contact con = new Contact();
        con.AssistantName = 'assistant';
        Contact c1 = new Contact(lastName='doe',firstName='John');
        Student__c st = new Student__c(Name='John',email__c='johndoe@gmail.com');
        
        sObject generalObject = new Account();
        generalObject = new Contact();
        generalObject = new Student__c();
        Student__c std2 = (Student__c)generalObject;
        
        //System.debug(acc);
        List<Account> accnts = [select Name,Phone from account limit 2];
        List<Hub__c> hubs = [select name from Hub__c];
		//system.debug('I have performed '+limits.getQueries()+' and I am allowed up to '+limits.getLimitQueries()+ 
          //           ' within this request'); 
          //  system.debug(hubs);
          

        for(Pod__c pod:[select id,name,(select id,name from Teams__r) from Pod__c where pod__c.Id='a015i00000FaRuJAAV']){
            for(team__c team:pod.teams__r){
        		System.debug(team.id +' '+team.name);        
            }
        }
        
          //List<team_member__c> ids = new List<team_member__c>();
          //ids = [select (select id from team_members__r) from Team__c where team__c.Id];
            //System.debug(ids);
        }
}