public class CreateDTWT {
	//public static List<Loan_Application__c> loanApps = [select Id,Name, Location__c, Business_unit__c, Stage__c, Sub_Stage__c from Loan_Application__c];
    public static void deleted(){
        List<DTWT__c> l = [select id from DTWT__c];
        delete l;
    }
  
    public static void createdtwtrecord(List<Loan_Application__c> loanApps){
        
    	//check if pod is available for the given loan application.
    	Map<String,Set<Pod__c>> locationPods = new Map<String,Set<Pod__c>>(); 
		locationPods = getLocationPods();
        //System.debug('location vs pod list '+locationPods);
        List<Loan_Application__c> loanApplications = checkPodForLocation(locationPods,loanApps);
        //System.debug('loanapps '+loanApps);
        //System.debug('pod is available for location for these loan Apps' + loanApplications);
        
        
    	//compare with stage substage of the metadata
        Map<Id,List<String>> appIdvsStatus;
        //List<Loan_Application__c> finallapplications = checkMetadataAvailbility(loanApplications);
        appIdvsStatus = checkMetadataAvailbility(loanApplications);
        //System.debug('loan app id vs status and record type of metadata check lapps '+appIdvsStatus);
        
        //Check if dtwt exists
        Set<Id> finallapplications = appIdvsStatus.keySet();
		removingExistingDTWT(finallapplications);
        //System.debug('final loanApps ids list' +finallapplications);
        
    	//create dtwt record.
        Map<Id,List<String>> loanApplicationIdVsStatusRT = new Map<Id,List<String>>();
        for(Id i : finallapplications){	
            loanApplicationIdVsStatusRT.put( i, appIdvsStatus.get(i)); 
        }
        
        for(Integer i ;i < loanApps.size();i++){
            
            if(!loanApplicationIdVsStatusRT.containsKey(loanApps[i].id)){
                loanApps.remove(i);
            }
        }
        //System.debug('final loanAppIdVsstatusRT ' +loanApplicationIdVsStatusRT); 
    	List<DTWT__c> dtwtList = new List<DTWT__c>(); 
    	dtwtList = createRecord(loanApps,loanApplicationIdVsStatusRT);  
        System.debug('list of dtwts --> '+dtwtList);
        
        //Assign DTWT to pod
        AssignPod.stampPodToDTWT(dtwtList,locationPods);
        
        
    }
     
    public static Map<String,Set<Pod__c>> getLocationPods(){
        Map<String,Set<Pod__c>> locationPods = new Map<String,Set<Pod__c>>();
        List<Pod__c> pods = Utility.getPods();
        	if(pods != null)
            {
                for(Pod__c p : pods)
                {
                    List<String> location = null;
                    if(String.isNotBlank(p.Locations__c))
                    {
                        location = p.Locations__c.split(';');
                    }
                    if(location != null)
                    {
                       for(String lo : location)
                       {
                         	lo = lo.toUpperCase();
                        	if(locationPods.containsKey(lo))
                         	{	
                            	locationPods.get(lo).add(p);
                         	}else{
                            	locationPods.put(lo,new Set<Pod__c>{p});
                         	}
                        }
                    }           
                }
            }
        
        //for(String x : locationPods.keySet()){
        //	System.debug(x+' '+locationPods.get(x));
        //}
        
        return locationPods;
    }
    
    public static List<Loan_Application__c> checkPodForLocation(Map<String,Set<Pod__c>> locationPods,List<Loan_Application__c> loanApps){
        List<Loan_Application__c> lapps = new List<Loan_Application__c>();
        if(loanApps.size()>0){
        	for(Loan_Application__c l : loanApps){
            	if(locationPods.containsKey((l.Location__c).toUpperCase())){
                	lapps.add(l);
            	}
        	}    
        }        
        
        return lapps;
    }
    
    public static Map<Id,List<String>> checkMetadataAvailbility(List<Loan_Application__c> loanApplications){
        List<DigiTwin_Stage_Sub_Stage_Master__c> metaData = Utility.getMetaData();
        //System.debug('All Metadata from db'+metaData);
    	//List<Loan_Application__c> finallapplications = new List<Loan_Application__c>();
        Map<Id,List<String>> appIdvsStatus = new Map<Id,List<String>>();
		
        for(Loan_Application__c l : loanApplications){
            for(DigiTwin_Stage_Sub_Stage_Master__c m : metaData){
                if(m.isActive__c && l.Stage__c.equalsIgnoreCase(m.Stage__c) && l.Sub_Stage__c.equalsIgnoreCase(m.Sub_Stage__c) && l.Business_unit__c.equalsIgnoreCase(m.Business_unit__c)){
                    //finallapplications.add(l);
                    List<String> stRt = new List<String>();
                    stRt.add(m.Status__c);
                    stRt.add(m.Record_Type__c);
                    appIdvsStatus.put(l.id,stRt);
                    //System.debug('bu of lapp and metadata '+l.Business_unit__c.equalsIgnoreCase(m.Business_unit__c));
                    //System.debug('MetaData BU and loan application BU '+m);
                    //System.debug('MetaData BU and loan application BU '+l.Stage__c+l.Sub_Stage__c+l.Business_unit__c);
                    
                    break;
                }
            }
        }
        
        return appIdvsStatus;
        //return finallapplications;
    }
    
    public static List<DTWT__c> createRecord(List<Loan_Application__c> finallapplications,Map<Id,List<String>> IdVsStatusRT){
        List<DTWT__c> dtwts = new List<DTWT__c>();
        try{
            
            for(Loan_Application__c l : finallapplications){
                //System.debug('loan business unit --> '+l.Business_unit__c == 'BIL');
                
                DTWT__c d = new DTWT__c(Stage__c=l.Stage__c, subStage__c=l.Sub_Stage__c,LoanApplicationId__c = l.Id, ApplicationName__c=l.Name,
                                        Product__c=l.Business_unit__c, Location__c=l.Location__c,SO__c = l.SO__c, RO__c = l.RO__c, scheme__c = l.scheme__c,
                                        Next_Task__c = l.Next_Task__c);
                list<String> statusRT= IdVsStatusRT.get(l.id);
                d.Status__c = statusRT[0];
                
                Id recordTypeId = Schema.SObjectType.DTWT__c.getRecordTypeInfosByName().get(statusRT[1]).getRecordTypeId();
				//System.debug(recordTypeId);
				d.RecordTypeId = recordTypeId;
                //System.debug('dtwt no. ---> '+d);
                dtwts.add(d);
            }
            //System.debug(dtwts);
            if(dtwts !=null && dtwts.size()>0){   
            	insert dtwts;    
            }
 			
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        return dtwts;
    }
    
    public static void removingExistingDTWT(Set<Id> loanids){
        
        List<DTWT__c> existingDTWT = Utility.getExistingDTWT(loanids);
        if(existingDTWT == null || existingDTWT.size()==0){
            return;
        }else{
        	for(DTWT__c d : existingDTWT){
            	if(loanids.contains(d.LoanApplicationId__c)){
                	loanids.remove(d.LoanApplicationId__c);
            	}
        	}    
        }
        	
    }	
    
}