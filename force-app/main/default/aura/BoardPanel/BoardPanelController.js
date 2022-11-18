({
	startGame : function(component, event, helper) {
        let gameModeComboBox = component.find("gameMode");
        let selectedGameMode = gameModeComboBox.get("v.value");
        
        component.set("v.selectedMode", selectedGameMode);
		console.log('you have click on start new game button and selected Mode is '+selectedGameMode);
        alert('Selected Mode is '+selectedGameMode);
	},
    
    reshuffleBoard : function(component, event, helper) {
		console.log('you have click on reshuffle button');
	},  
})