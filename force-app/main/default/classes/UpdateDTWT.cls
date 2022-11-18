public class UpdateDTWT {
	static List<Id> users ;
    static List<Id> podIds;
    
    public static void updateDTWTfilds(List<Loan_Application__c> lapps, Map<Id,Loan_Application__c> oldLoanApps){
        //create dtwt for a loan application whose dtwt is not already there
        //CreateDTWT.createdtwtrecord(lapps);
        users = new List<Id>();
        podIds = new List<Id>();
        
        Set<Id> Appids = new Set<Id>();
        Map<Id,Loan_Application__c> getLoanApp = new Map<Id,Loan_Application__c>();
        for(Loan_Application__c l : lapps){
            Appids.add(l.Id);
            getLoanApp.put(l.Id,l);
        }
        List<DTWT__c> dtwts = Utility.getExistingDTWT(Appids);
        Map<Id,List<String>> appIdvsStatus;
        appIdvsStatus = CreateDTWT.checkMetadataAvailbility(lapps);
        //System.debug(Appids);
        //System.debug(dtwts);
       	System.debug('Check Metadata availability,  appIdvsStatus'+ appIdvsStatus);
        if(appIdvsStatus == null || appIdvsStatus.size()==0){
            System.debug(' MetaData is not available '+ appIdvsStatus);
        }
        
        try{       
        if(dtwts != null && dtwts.size()>0){
            for(DTWT__c d : dtwts){
				Loan_Application__c l = getLoanApp.get(d.LoanApplicationId__c);
                Loan_Application__c oldl = oldLoanApps.get(d.LoanApplicationId__c);
                d.Stage__c=l.Stage__c;
                d.subStage__c=l.Sub_Stage__c;
                d.ApplicationName__c=l.Name;
                d.SO__c = l.SO__c;
                d.RO__c = l.RO__c;
                d.scheme__c = l.scheme__c;
                d.Next_Task__c = l.Next_Task__c;
                List<String> statusRT = appIdvsStatus.get(d.LoanApplicationId__c);
                if(statusRT != null && statusRT.size()>0){
                    d.Status__c = statusRT[0];
                	Id recordTypeId = Schema.SObjectType.DTWT__c.getRecordTypeInfosByName().get(statusRT[1]).getRecordTypeId();
                	d.RecordTypeId = recordTypeId;     
                }
                
                if(oldl.Stage__c != l.Stage__c){
                	Integer s = Utility.getNextStageSequence(l.Stage__c,d.Pod__c);
                	d.Sequence__c = ++s;
                	//d.Status__c = 'In Queue';
                	if(d.OwnerId != null){
                  		users.add(d.OwnerId);    
                	}
                	d.OwnerId = Utility.getpodQueue(l.Stage__c,d.Pod__c);
                	d.Team__c = null;
                	podIds.add(d.Pod__c);    
                }
                if(d.Status__c == 'Hold'){
            		d.FTNR__c = true;
                	d.Pod__c = null;
            	}
                
            }    
        }
        System.debug('after loan app update dtwt --> '+dtwts);
        	
           if(dtwts != null && dtwts.size()>0){
        		update dtwts;    
        	}    
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        
        
    }
    
    //sequence will change for each of them
	//status will become inqueue again at each stage change
	//hold -> inqueue or completed -> inqueue
    public static void stageChange(List<DTWT__c> newDtwts, Map<Id,DTWT__c> oldDtwts){
	 //users = new list<Id>();
        /**
         for(DTWT__c d : newDtwts){
            //get Trigger.old and get the previous stage
            DTWT__c oldDTWT = oldDtwts.get(d.Id);			
            if(d.Status__c == 'Completed'){
            	// than check for all the available dtwts for the new changed stage.and get sequence for that stage and change status,stage,substage,and sequence accordingly.
                if(oldDTWT.Stage__c == 'CPA Login'){
                    d.Stage__c = 'Underwriting';
                    d.subStage__c = 'Underwriting Pending';
                    Integer s = Utility.getNextStageSequence('Underwriting',d.Pod__c);
                    d.Sequence__c = ++s;
                    d.Status__c = 'In Queue';
                    if(d.OwnerId != null){
                    	users.add(d.OwnerId);    
                    }
                    d.OwnerId = Utility.getpodQueue('Underwriting',d.Pod__c);
                    d.Team__c = null;
                    
                }else if(oldDTWT.Stage__c == 'Underwriting'){
                    d.Stage__c = 'Maker';
                    d.subStage__c = 'SBD Ops Maker Pending';
                    Integer s = Utility.getNextStageSequence('Maker',d.Pod__c);
                    d.Sequence__c = ++s;
                    d.Status__c = 'In Queue';
                    System.debug(d.OwnerId);
                    if(d.OwnerId != null){
                    	users.add(d.OwnerId);    
                    }
                    d.OwnerId = Utility.getpodQueue('CPA',d.Pod__c);
                    d.Team__c = null;
                    
                }else if(oldDTWT.Stage__c == 'Maker'){
                    d.Stage__c = 'Checker';
                    d.subStage__c = 'SBD Ops Checker Pending';
                    Integer s = Utility.getNextStageSequence('Checker',d.Pod__c);
                    d.Sequence__c = ++s;
                    d.Status__c = 'In Queue';
                    if(d.OwnerId != null){
                    	users.add(d.OwnerId);    
                    }
                    System.debug('maker to checker dtwt ------> '+d);
                    d.OwnerId = Utility.getpodQueue('CPA',d.Pod__r.Name);
                    System.debug('maker to checker dtwt Pod NAme  ------> '+d.Pod__r.Name);
                    d.Team__c = null;
                    
                }else if(oldDTWT.Stage__c == 'Checker'){
                    d.Stage__c = 'Submitted to finnone';
                    d.subStage__c = '';
                    d.Sequence__c = 0;
                    d.Status__c = 'None';
                    if(d.OwnerId != null){
                    	users.add(d.OwnerId);    
                    }
                    d.OwnerId = '0055i000002Qv5uAAC';
                    d.Team__c = null;
                }
                
            }else if(d.Status__c == 'Hold'){
            	d.FTNR__c = true;
                d.Pod__c = null;
            }else if(d.Manually_Assigned__c == true && oldDTWT.Manually_Assigned__c == false){
             	users.add(oldDTWT.OwnerId);   
            }
        } 
         * */
        
        
        for(DTWT__c d : newDtwts){
            //get Trigger.old and get the previous stage
            DTWT__c oldDTWT = oldDtwts.get(d.Id);
        	if(d.Manually_Assigned__c == true && oldDTWT.Manually_Assigned__c == false){
           		users.add(oldDTWT.OwnerId);   
        	}
        }
    }
    
    //call file allocation after update of dtwt.
    public static void allocateUserToNewFile(List<DTWT__c>  dtwts){ 
        if(users != null && users.size()>0){
            List<Team_Member__c> teamMembers = new List<Team_Member__c>();
        	
            System.debug('users and podids '+users +podIds);
            //team memebers to be assigned.
            
            List<Team_Member__c> teamMembersToBeAllocated = Utility.getTeamMembersByUserId(users);
        	System.debug('updateDTWT --> allocateUserToNewfile -->teamMembersToBeAllocated '+teamMembersToBeAllocated);
            /**
            if(teamMembersToBeAllocated==null && teamMembersToBeAllocated.size()==0){
            	System.debug('teamMembersToBeAllocated is nulll ---->>');    
            }
            **/
            //dtwts to be assigned with
            
            List<Team_Member__c> allocateMemberToDTWT = new List<Team_Member__c>();
            try{
            	 allocateMemberToDTWT = [select id, name, isOnline__c, podId__c, Skillset__c, User__c, Team__c from Team_Member__c where PodId__c in:podIds];    
            }catch(Exception e){
                System.debug(e.getMessage());
                System.debug(e.getStackTraceString());
            }
            
            
            System.debug('updateDTWT --> allocateUserToNewfile->allocateMemberToDTWT '+allocateMemberToDTWT);
            if(teamMembersToBeAllocated != null && teamMembersToBeAllocated.size()>0){
            	teamMembers.addAll(teamMembersToBeAllocated);    
            }
            if(allocateMemberToDTWT != null && allocateMemberToDTWT.size()>0){
            	teamMembers.addAll(allocateMemberToDTWT);    
            }
            
            
			//System.debug('1. updateDTWT --> allocateUserToNewfile --> teamMembers '+teamMembers);
            if(teamMembers != null && teamMembers.size()>0){
               // System.debug('2. updateDTWT --> allocateUserToNewfile --> teamMembers '+teamMembers);
         		FileAllocation.FileAllocationToTeamMember(teamMembers);   
        	}
        }
    }
    
}