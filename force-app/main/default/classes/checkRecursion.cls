public Class checkRecursion{

    private static boolean run = true;
    public static boolean runOnce(){
      System.debug('value of run '+run);
      if(run){
       run=false;
       return true;
      }else{
       return run;
      }
    }
    
    private static boolean afterupdateloanApp = true;
    public static boolean afterUpdateLoanAppTrigger(){
       System.debug('value of afterupdateloanApp '+afterupdateloanApp);
        if(afterupdateloanApp){
           afterupdateloanApp=false;
           return true;
          }else{
            return afterupdateloanApp;
          }
    }

}