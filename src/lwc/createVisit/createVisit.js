import {LightningElement, track, wire} from 'lwc';
import { getObjectInfo} from 'lightning/uiObjectInfoApi';
import getKids from '@salesforce/apex/CreateVisitController.getKids';
import getRelatives from '@salesforce/apex/CreateVisitController.getRelatives';
import Visit__c_OBJECT from '@salesforce/schema/Visit__c';
import { createRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class CreateVisit extends LightningElement {
    @wire(getObjectInfo, { objectApiName: Visit__c_OBJECT })
    objectInfo;
    @wire(getRelatives)
    relatives;
    @track value = '';
    @track optionsArray = [];
    @track wasWithKidValue = '';
    @track optionsWasWthKidArray = [];

    get options(){
        return this.optionsArray;
    }
    @wire(getKids)
    connectedCallback() {
        getKids()
            .then(response=>{
                let arr = [];
                for(let i=0; i<response.length; i++) {
                    arr.push({label: response[i].Name, value: response[i].Id})
                }
                this.optionsArray = arr;
            })
    }

    get wasWithKidOptions(){
        return this.optionsWasWthKidArray;
    }

    handleChangedKidValue(event) {
        this.value = event.target.value;
        getRelatives({selectedKidId: this.value})
            .then(response => {
                let arr = [];
                for (let i = 0; i < response.length; i++) {
                    arr.push({label: response[i].Name, value: response[i].Id})
                }
                this.optionsWasWthKidArray = arr;
            })

    }

    handleChangedWhoWasValue(event){
        this.wasWithKidValue = event.target.value;
    }

    createVisit(){
        let fields = {'Kid__c' : this.value, 'Was_with_Kid__c' : this.wasWithKidValue};
        let objRecordInput = {'apiName' : 'Visit__c', fields};
        createRecord(objRecordInput).then(response => {
            const evt = new ShowToastEvent({
                title: 'Visit Created '+ response.fields.Name.value,
                message: 'Operation successful ',
                variant: 'success',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
            this.value ='';
            this.wasWithKidValue ='';
        }).catch(error => {
            const evt = new ShowToastEvent({
                title: 'Error creating Visit',
                message: 'Operation with Error',
                variant: 'error',
                mode: 'dismissible'
            });
            this.dispatchEvent(evt);
            console.log(error);
        });
    }
}