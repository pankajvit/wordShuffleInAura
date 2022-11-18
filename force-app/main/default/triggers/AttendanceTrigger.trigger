trigger AttendanceTrigger on Attendance__c (after insert, after update) {

    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate) ){
        Set<Id> idsOfMember = new Set<Id>();
        Map<Id,String> MemberVsStatus = new Map<Id,String>();
        for(Attendance__c a : Trigger.new){
            idsOfMember.add(a.Team_Member__c);
            MemberVsStatus.put(a.Team_Member__c,a.Current_Status__c);
        }
        
        try{
            List<Team_Member__c> teamMemberList = new List<Team_Member__c>();
        	for(Team_Member__c m : [select id,Name,isOnline__c from Team_Member__c where id in: idsOfMember]){
            	String status = MemberVsStatus.get(m.id);
                if(status == 'Present'){
                    m.isOnline__c = true;
                }else{
                    m.isOnline__c = false;
                }
                
                teamMemberList.add(m);
        	}
            
            if(teamMemberList != null && teamMemberList.size()>0){
                update teamMemberList;
                
            }
            
        }catch(Exception e){
            System.debug('error : ' + e.getMessage());
            System.debug('Error In ' + e.getStackTraceString());
        }
        
        //System.debug(Trigger.new);
    }
}