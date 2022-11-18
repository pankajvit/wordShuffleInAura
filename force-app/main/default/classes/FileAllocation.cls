public class FileAllocation {
    public static void FileAllocationToTeamMember(List<Team_Member__c> TeamMembers){
        List<Team_Member__c> tmembers = new List<Team_Member__c>();
        tmembers.addAll(TeamMembers);
        //check if the team member is already allocated to some dtwt, So remove it from the list
        List<Id> allocatedUsers = Utility.getOwnerIdsOfDTWTUsers();
        //System.debug('remove these users __--->'+allocatedUsers);
        if(allocatedUsers != null && allocatedUsers.size()>0){
        	for(Integer i=0;i<tmembers.size();i++){
            	if(allocatedUsers.contains(tmembers[i].User__c)){
                	tmembers.remove(i);
            	}
        	}    
        }
        
        
        Map<Id,List<DTWT__c>> PodVsDTWT = new Map<Id,List<DTWT__c>>();
        Map<Id,Pod__c> IdVsPod = new Map<Id,Pod__c>();
        List<id> podIdList = new List<id>();
        for(Team_Member__c tm : tmembers){
                //Check if team member's status is present
                if(tm.isOnline__c == true){
                	//team -> pod -> dtwts list
 					Id podId = tm.podId__c; 
                    podIdList.add(podId); 
                }
        }
        IdVsPod = Utility.getIdVsPod(podIdList);
        //System.debug('id vs pod  '+IdVsPod);
        PodVsDTWT = Utility.getPodVsDTWT(podIdList);
        System.debug('podID vs dtwt ----> '+PodVsDTWT);
        //inqueue status dtwt assignment
        List<DTWT__c> listOfIdealDTWT = new List<DTWT__c>();
        //System.debug(tmembers);
       
        for(Team_Member__c tm : tmembers){
        	Id podId = tm.podId__c;
            List<DTWT__c> dtwts = PodVsDTWT.get(podId);
            //System.debug(dtwts);
            Integer minSequence = 2147483647;
            DTWT__c idealDTWT;
            
            //check inqueue, skillset vs stage of loan application -> assign dtwt to user -> change status to assigned of dtwt.    
            System.debug('dtwts ------> '+ dtwts);
            
            if(dtwts != null && dtwts.size()>0){
            	for(DTWT__c d : dtwts){
                	List<String> sklsets = tm.Skillset__c.split(';');
                	System.debug(sklsets);
                	if(d.Status__c == 'In Queue' && sklsets.contains('Login') && d.Stage__c =='Data Verification'){
                    	if(minSequence>d.Sequence__c){
                        	minSequence = (Integer)d.Sequence__c;
                        	idealDTWT = d;
                            idealDTWT.Status__c = 'Assigned';
                        	System.debug(idealDTWT);
                    	}    
                	}
                    else if(d.Status__c == 'In Queue' && sklsets.contains('Maker') && d.Stage__c =='Maker'){
                    	if(minSequence>d.Sequence__c){
                        	minSequence = (Integer)d.Sequence__c;
                        	idealDTWT = d;
                            idealDTWT.Status__c = 'Assigned';
                        	System.debug(idealDTWT);
                    	}    
                	}
                    else if(d.Status__c == 'In Queue' && sklsets.contains('Checker') && d.Stage__c =='Checker'){
                    	if(minSequence>d.Sequence__c){
                        	minSequence = (Integer)d.Sequence__c;
                        	idealDTWT = d;
                            idealDTWT.Status__c = 'Assigned';
                        	System.debug(idealDTWT);
                    	}    
                	}
                    else if(d.Status__c == 'In Queue' && sklsets.contains('Underwriter') && d.Stage__c =='Underwriting'){
                    	System.debug(d);
                        if(minSequence>d.Sequence__c){
                        	minSequence = (Integer)d.Sequence__c;
                            System.debug(minSequence);
                        	idealDTWT = d;
                            idealDTWT.Status__c = 'Assigned';
                        	System.debug(idealDTWT);
                    	}    
                	}
            	}    
            }
            
            
            if(tm.User__c != null && idealDTWT != null){
                System.debug(tm.User__c);
                idealDTWT.OwnerId = tm.User__c;
                idealDTWT.Team__c = tm.Team__c;
                idealDTWT.Sequence__c =0;
                //update the sequence of the rest of the dtwts for the same stage and Business Unit 
                
            	listOfIdealDTWT.add(idealDTWT);
            }
        }
        
        try{
        	for(DTWT__c dt : listOfIdealDTWT){
         		Utility.UpdateSequence(dt.Stage__c,dt.Pod__c);   
        	}
        //System.debug(listOfIdealDTWT);
        	if(listOfIdealDTWT != null && listOfIdealDTWT.size()>0){
        		update listOfIdealDTWT;    
        	}    
        }catch(Exception e){
            System.debug('error : ' + e.getMessage());
            System.debug('Error In ' + e.getStackTraceString());
        }
        
    }
}