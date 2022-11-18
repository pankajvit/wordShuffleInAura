trigger DTWTTrigger on DTWT__c (before update,after update) {
    
    if(trigger.isBefore && trigger.isUpdate){
    	if(checkRecursion.runOnce()){
            System.debug('isbefore isupadate ran ');
        	UpdateDTWT.stageChange(Trigger.new,Trigger.OldMap);
        //System.debug(Trigger.new);
        //System.debug(Trigger.OldMap);
    	}
    }
    
    if(trigger.isAfter && trigger.isUpdate){
    	if(checkRecursion.afterUpdateLoanAppTrigger()){
            System.debug('isafter isupadate ran ');
        	UpdateDTWT.allocateUserToNewFile(Trigger.new);
        	/**
        	dtwts = Trigger.new;
        	for(DTWT__c d : dtwts){
            System.debug('Stage of dtwt '+d.Stage__c);
            List<Team_Member__c> teamMembers = Utility.getTeamMembers(d.Stage__c);     
       		//System.debug(' Team members -----> '+teamMembers);
        	FileAllocation.FileAllocationToTeamMember(teamMembers);
        	}
			**/
        }
        //System.debug(Trigger.new);
        //System.debug(Trigger.OldMap);
        
    }
    
}
//CPA -> UW -> Maker -> Checker
//inqueue -> assigned -> hold/complete.