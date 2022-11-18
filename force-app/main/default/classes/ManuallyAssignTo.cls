public class ManuallyAssignTo {
    @AuraEnabled
    public static List<Team_Member__c> getTeamMemberList(Id dtwtId){
        DTWT__c dtwt = [select Hub_Name__c, Pod__c, Status__c,Team__c,RecordTypeId from DTWT__c WHERE Id=: dtwtId];
        System.debug('Manually assign to apex ----> '+ dtwt);
        List<Team_Member__c> memberList= [select id, Name from Team_Member__c where team__c=:dtwt.Team__c];
        System.debug('Manually assign to apex ----> '+ memberList);
        return memberList;
    }
    @AuraEnabled
    public static void assignTeamMemberToDTWT(CustomWrapper wrapper){
        System.debug('Manually assign teammember to dtwt teamMemberId => '+ wrapper.teamMemberId);
        System.debug('Manually assign teammember to dtwt dtwtid => '+ wrapper.dtwtid);
        
        DTWT__c dtwt = [select Hub_Name__c, Pod__c, Status__c,Team__c, RecordTypeId, OwnerId, Manually_Assigned__c, Manually_Assigned_To__c from DTWT__c WHERE Id=: wrapper.dtwtid];
        System.debug('Manually assign teammember to dtwt dtwt => '+ dtwt);
        Team_Member__c tMember= [select id, Name,User__c from Team_Member__c where Id=:wrapper.teamMemberId];
        System.debug('Manually assign teammember to dtwt teammember => '+ tMember);
        String status='';
        List<DTWT__C> dtwts = [select  id,Name,OwnerId from DTWT__c where OwnerId =:tMember.User__c];
        System.debug('Manually assign teammember to dtwt dtwts => '+ dtwts);
        if(dtwts == null || dtwts.size()==0){
            status = 'Assigned';
        }else{
            status = 'In Queue';
        }
        dtwt.Status__c = status;
        dtwt.OwnerId = tMember.User__c;
        dtwt.Manually_Assigned__c = true;
        dtwt.Manually_Assigned_To__c = tMember.Name;    
        System.debug('Manually assign teammember to dtwt => '+ dtwt);
        update dtwt;
    }
}