public class MetadataDao {
    public static Map<String,Set<DigiTwin_Stage_Sub_Stage_Master__c>> getBU_StageSubstage(){
        Map<String,Set<DigiTwin_Stage_Sub_Stage_Master__c>> buVsmeta;
        buVsmeta = new Map<String,Set<DigiTwin_Stage_Sub_Stage_Master__c>>(); 
         
        List<DigiTwin_Stage_Sub_Stage_Master__c> tempMap= new List<DigiTwin_Stage_Sub_Stage_Master__c>
                ([SELECT Business_Unit__c,Completion_Type__c,FTNR_to_Update__c,Id,isActive__c,
                  Name,SLA__c,Stage__c,Status__c,Sub_Stage__c FROM DigiTwin_Stage_Sub_Stage_Master__c]);

            

        if(tempMap != null && tempMap.size()>0)
        {
            // Iterating metadata and put each record into map
            for(DigiTwin_Stage_Sub_Stage_Master__c d:tempMap)
            {
                if(buVsmeta.containsKey(d.Business_Unit__c))
                {
                    buVsmeta.get(d.Business_Unit__c).add(d);
                }
                else
                {
                    buVsmeta.put(d.Business_Unit__c,new Set<DigiTwin_Stage_Sub_Stage_Master__c>{d});
                }
            }
        }
        
        if(buVsmeta.size()>0 || buVsmeta != null){
            return buVsmeta;
        }else{
            return null;
        }	
    }
}