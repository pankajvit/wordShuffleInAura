trigger TeamMemberTrigger on Team_Member__c (after insert, after update) {
    
	if(trigger.isAfter && trigger.isInsert){
        //FileAllocation.FileAllocationToTeamMember(Trigger.new);
        //System.debug(Trigger.new);
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        FileAllocation.FileAllocationToTeamMember(Trigger.new);
       //System.debug(Trigger.new);
    }
}