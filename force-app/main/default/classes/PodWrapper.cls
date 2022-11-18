global class PodWrapper implements Comparable {

    public Pod__c pod;
    
    // Constructor
    public PodWrapper(Pod__c op) {
        pod = op;
    }
    
    // Compare Pods based on the Pod related dtwt__r.size().
    global Integer compareTo(Object compareTo) {
        // Cast argument to PodWrapper
        PodWrapper compareToOppy = (PodWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (pod.DTWTs__r.size() > compareToOppy.pod.DTWTs__r.size()) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (pod.DTWTs__r.size() < compareToOppy.pod.DTWTs__r.size()) {
            // Set return value to a negative value.
            returnValue = -1;
        }        
        return returnValue;       
    }
}