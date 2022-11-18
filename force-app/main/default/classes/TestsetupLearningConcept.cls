public class TestsetupLearningConcept {
    public static void methodchecking(){
        List<Pod__c> podList = new List<Pod__c>();
    	podList = [select id,Name from Pod__c];
        //system.debug(podList);
        List<Id> ids = new List<Id>();
        for(Pod__c p : podList){
            ids.add(p.id);
        }
		Map<id,Pod__c> idVsPods = new Map<id,Pod__c>([select id,Name from Pod__c where id in : ids]);
        System.debug(idVsPods);
    }
}