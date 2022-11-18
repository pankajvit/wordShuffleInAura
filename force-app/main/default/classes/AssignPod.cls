public class AssignPod {
    
    public static void stampPodToDTWT(List<DTWT__c> dtwts,Map<String,Set<Pod__c>> locationPods){
        system.debug(dtwts);
        system.debug(locationPods);
        //stamping sequence
        try{
        		for(DTWT__c d : dtwts){
                    List<Pod__c> BULocationPods = new List<Pod__c>();
                    for(Pod__c p : locationPods.get((d.Location__c).toUpperCase())){
                        if((p.Product__c.split(';')).contains(d.Product__c.toUpperCase())){
                          BULocationPods.add(p);
                        }
                    }
                    System.debug(BULocationPods);
                
                    //sort BULocationPods on the basis of DTWT__r.size() related to that pod
                    	BULocationPods.sort();
                        if(BULocationPods != null && BULocationPods.size()>0)
                        d.Pod__c = BULocationPods.get(0).id;
                        Integer s = Utility.getNextStageSequence(d.Stage__c,d.Pod__c);	    	 
                        d.Sequence__c = ++s;
                        
                        String recordType = Schema.getGlobalDescribe().get('DTWT__c').getDescribe().getRecordTypeInfosById().get(d.RecordTypeId).getName();
                        if(recordType == 'Underwriting'){
                            d.OwnerId = Utility.getpodQueue('Underwriting',d.Pod__c);    
                        }else if(recordType == 'CPA Login' || recordType == 'CPA Disbursal' ){
                            d.OwnerId = Utility.getpodQueue('CPA',d.Pod__c);
                        }
                
            	 //System.debug(d.Pod__c);
        		}
            	if(dtwts.size()>0 && dtwts != null){
        			update dtwts;	    
        		}    
        	}catch(Exception e){
            	System.debug(e.getMessage());
        	}    	 
        
    }
}