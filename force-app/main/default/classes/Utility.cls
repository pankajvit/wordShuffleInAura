public class Utility {
    public static List<Pod__c> pods;
    public static List<DigiTwin_Stage_Sub_Stage_Master__c> metaData;
    public static List<DTWT__c> dtwts;
    public static List<Pod__c> getPods(){
        pods = [SELECT Id,Locations__c,Name,Product__c from Pod__c];
        return pods;
    }
    public static List<DigiTwin_Stage_Sub_Stage_Master__c> getMetaData(){
        metaData = [select Id,Stage__c,Sub_Stage__c,isActive__c,Business_unit__c,Status__c,Record_Type__c from DigiTwin_Stage_Sub_Stage_Master__c];
        return metaData;
    }
    //get dtwt for given loan application ids
    public static List<DTWT__c> getExistingDTWT(Set<Id> lids){
        dtwts = [select Id, name, LoanApplicationId__c,Pod__c,Stage__c,subStage__c,ApplicationName__c,SO__c,RO__c,scheme__c,Next_Task__c,Status__c,RecordTypeId,Sequence__c,OwnerId,Team__c,FTNR__c from DTWT__c where LoanApplicationId__c in : lids];
        return dtwts;
    }
    //public static Integer getNextSequence(Id podId){
    //    List<DTWT__c> record = [select id, Sequence__c from DTWT__c where Pod__c = :podId order by sequence__c desc limit 1];
    //    Integer maxSequence = 0;
    //    if(record ==null && record.size() == 0){
    //    	return 0;
    //    }
    //    maxSequence = (Integer)record[0].Sequence__c;
    //    return maxSequence;
    //}
    public static Map<id,Pod__c> getIdVsPod(List<Id> ids){
        Map<id,Pod__c> idVsPods = new Map<id,Pod__c>([select id,Name from Pod__c where id in : ids]);
        return idVsPods;
    }
    public static Map<Id,List<DTWT__c>> getPodVsDTWT(List<Id> lids){
        List<Pod__c> pods = [select id,(select id,Status__c,Stage__c,Sequence__c,OwnerId,name,Pod__c from DTWTs__r) from Pod__c where id in:lids];
        Map<Id,List<DTWT__c>> idVsDtwts = new Map<Id,List<DTWT__c>>();
        for(Pod__c p : pods){
            idVsDtwts.put(p.id,p.DTWTs__r);
        }
        return idVsDtwts;
    }
    
    //Stage specific sequence
    public static Integer getNextStageSequence(String Stage,Id pod){
        List<DTWT__c> record = [select id, Sequence__c from DTWT__c where Stage__c = :Stage and Pod__c =:pod order by sequence__c desc limit 1];
        Integer maxSequence = 0;
        if(record ==null || record.size() == 0){
        	return 0;
        }
        maxSequence = (Integer)record[0].Sequence__c;
        return maxSequence;
    }
    //Update the sequence__c of remaining dtwts
    public static void UpdateSequence(String Stage,Id pod){
        List<DTWT__c> record = [select id, Sequence__c from DTWT__c where Stage__c = :Stage and Pod__c =:pod order by sequence__c asc ];
        if(record != null && record.size() > 0){
            for(Integer x=1;x<record.size()-1;x++){
                record[x].Sequence__c = record[x-1].Sequence__c;
            }
        	update record;
        }
    } 
    
    public static List<Team_Member__c> getTeamMembersByUserId(List<Id> users){
        List<Team_Member__c> teamMembers = new List<Team_Member__c>();
        teamMembers = [select id, name, isOnline__c, podId__c, Skillset__c, User__c, Team__c from Team_Member__c where User__c in : users];
        return teamMembers;
    }
    
    public static List<Id> getUserDTWTUsers(){
        List<DTWT__C> dtwts = [select id, OwnerId, Name from DTWT__c];
        List<Id> ids = new List<Id>();
        for(DTWT__c d : dtwts){
            ids.add(d.OwnerId);
        }
        return ids;
    }
    
    public static List<Id> getOwnerIdsOfDTWTUsers(){
     List<DTWT__C> dtwts = [select  OwnerId from DTWT__c];
        List<Id> ids = new List<Id>();
        for(DTWT__c d : dtwts){
            ids.add(d.OwnerId);
        }
        return ids;
    }
    
    public static List<Team_Member__c> getTeamMembers(string s){
        List<Id> allocatedUsers = Utility.getOwnerIdsOfDTWTUsers();
        List<Team_Member__c> allmembers = [select id, User__c, name,Skillset__c, isOnline__c,PodId__c, Team__c  from Team_Member__c where isOnline__c = true];
        List<Team_Member__c> UnderwriterList = new List<Team_Member__c>();
        List<Team_Member__c> CpaList = new List<Team_Member__c>();
        List<Team_Member__c> Makerist = new List<Team_Member__c>();
        List<Team_Member__c> CheckerList = new List<Team_Member__c>();
        //List<Team_Member__c> temp1 = new List<Team_Member__c>();
        if(allmembers != null && allmembers.size()>0){
            for(Team_Member__c t : allmembers){
                List<String> tempSkillList = t.Skillset__c.split(';');
                if(tempSkillList.contains('Underwriter') && !allocatedUsers.contains(t.User__c)){
                    UnderwriterList.add(t);
                }
                if(tempSkillList.contains('CPA Login') && !allocatedUsers.contains(t.User__c)){
                    CpaList.add(t);
                }
                if(tempSkillList.contains('Checker') && !allocatedUsers.contains(t.User__c)){
                    CheckerList.add(t);
                }
                if(tempSkillList.contains('Maker') && !allocatedUsers.contains(t.User__c)){
                    Makerist.add(t);
                }
            }
        }
        if(s.equals('Underwriter')){
            return UnderwriterList;
        }
        else if(s.equals('Checker')){
            return CheckerList;
        }
        else if(s.equals('Maker')){
            return Makerist;
        }
        else{
            return CpaList;
        }
    }
    
    public static Id getpodQueue(String Stage,Id podId){
		List<Pod__c> pod = [select name from Pod__c where Id=:podId limit 1];
        String podName;
        if(pod != null && pod.size()>0){
            podName = pod[0].Name;
        }
        String QueueName;
        if(Stage == 'Maker' || Stage == 'Checker'|| Stage == 'Data Verification'){
            Stage = 'CPA';
        }
        QueueName = podName+'_'+Stage;
        //System.debug('QueueName  -------> '+QueueName);
        List<Group> Queue = [Select Id, Name from Group where type='Queue' and Name =: QueueName limit 1];
		//System.debug('Queue for the pod -------> '+Queue);
        if(Queue != null && Queue.size()>0 && Queue[0].Id !=null){
        	return Queue[0].Id;    
        }else{
            //System.debug('default is running ');
            return '0055i000002Qv5uAAC';
        }
        
    }
    
    
}