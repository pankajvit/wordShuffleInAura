trigger LoanAppTrigger on Loan_Application__c (after insert, after update) {
    if(trigger.isAfter && trigger.isInsert ){
        //System.debug('Trigger.new in loanapp trigger '+Trigger.new);
        CreateDTWT.createdtwtrecord(Trigger.new);
    }
    else if(trigger.isAfter && trigger.isUpdate){
        UpdateDTWT.updateDTWTfilds(Trigger.new,Trigger.OldMap);
        //System.debug('working fine');
    }
}