import { api, LightningElement,track} from 'lwc';
import getTeamMemberList from  "@salesforce/apex/ManuallyAssignTo.getTeamMemberList";
import assignTeamMemberToDTWT from "@salesforce/apex/ManuallyAssignTo.assignTeamMemberToDTWT"

export default class ManualAssignment extends LightningElement {
    @track
    value = '';
    @api
    recordId;
    @track 
    data1 = [];
    @track
    showUserList = false;
    handleClick(){
        getTeamMemberList({dtwtId: this.recordId}).then((result)=>{
            let data = JSON.parse(JSON.stringify(result));
            let lstOption = [];
            for (var i = 0;i < data.length;i++) {
                lstOption.push({label: data[i].Name, value: data[i].Id});
            }
            this.data1 = lstOption;
        })
        .catch((error)=>{
            console.log("error in retreving team members");
        });

        this.showUserList =true;
    }

    
    get options() {
        return this.data1;
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    assignMember(){
        let parameterObject = {
            dtwtid: this.recordId,
            teamMemberId: this.value
        };
        assignTeamMemberToDTWT({wrapper:parameterObject})
        .then((result)=>{
            this.showUserList =false;
        }).catch((error)=>{
            console.error("error in updating dtwt");
        })
    }

}