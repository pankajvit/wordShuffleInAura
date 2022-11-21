({
	startGame : function(component, event, helper) {
        let gameModeComboBox = component.find("gameMode");
        let selectedGameMode = gameModeComboBox.get("v.value");
        
        const selectedMode = component.get("v.selectedMode");
        component.set("v.selectedMode", selectedGameMode);
        
        if(selectedMode){
            const boardComp = component.find("boardComp");
            // call aura method
            boardComp.startGame();
        }
		console.log('you have click on start new game button and selected Mode is '+selectedGameMode);
        alert('Selected Mode is '+selectedGameMode);
	},
    
    reshuffleBoard : function(component, event, helper) {
		console.log('you have click on reshuffle button');
        const boardComp = component.find("boardComp");
        boardComp.reshuffleBoard();
        component.set("v.reshuffleDisabled", true);
	}, 
    
    onResultHandler : function(component, event, helper){
        const result = event.getParam("result");
        if(result === "win"){
           component.set("v.reshuffleDisabled", true); 
           
        } else {
           component.set("v.reshuffleDisabled", false); 
        }
        helper.addResultRecord(component, result);
    }
})