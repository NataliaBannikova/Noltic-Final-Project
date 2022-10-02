import {LightningElement, track, wire} from 'lwc';
import { getObjectInfo} from 'lightning/uiObjectInfoApi';
import getKids from '@salesforce/apex/VisitCardController.getKids';
import Visit__c_OBJECT from '@salesforce/schema/Visit__c';
import { createRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {refreshApex} from "@salesforce/apex";

export default class CreateVisit extends LightningElement {
    @wire(getObjectInfo, { objectApiName: Visit__c_OBJECT })
    objectInfo;
    @wire(getKids)
    kidsLst;
    @track value = '';
    @track optionsArray = [];
    @track cardVisible = false;
    timeFieldValue;

    get options(){
        return this.optionsArray;
    }

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

    handleChangedKidValue(event){
        this.value = event.target.value;
        console.log(event.target.value);
    }

    handleTimeChange(event){
        this.timeFieldValue = event.detail.value;
    }

    createVisit(){
        let fields = {'Kid__c' : this.value, 'Time_leaving__c' : this.timeFieldValue};
        let objRecordInput = {'apiName' : 'Visit__c', fields};
        createRecord(objRecordInput).then(response => {
            // alert('Visit created with Id: ' +response.id);
                const evt = new ShowToastEvent({
                    title: 'Visit Created '+ response.id,
                    message: 'Operation successful ',
                    variant: 'success',
                    mode: 'dismissible'
                });
                this.dispatchEvent(evt);

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