import { LightningElement, wire } from 'lwc';
import { getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import Visit__c_OBJECT from '@salesforce/schema/Visit__c';
import WhoWasWithKid_FIELD from '@salesforce/schema/Visit__c.Who_was_with_Kid__c';
import { createRecord } from 'lightning/uiRecordApi';

export default class VisitCard extends LightningElement {
    @wire(getObjectInfo, { objectApiName: Visit__c_OBJECT })
    objectInfo;
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: WhoWasWithKid_FIELD
    })
    WhoWasWithKidPicklistValues;
    strKid;
    timeFieldValue;
    strWhoWasWithKid;

    kidChangedHandler(event){
        this.strKid = event.target.value;
    }

    timeLeavingChangedHandler(event){
        this.timeFieldValue = event.target.value;
    }

    createVisit(){
        let fields = {'Kid' : this.strKid, 'Time Leaving' : this.timeFieldValue, 'Who Was With Kid?' : this.strWhoWasWithKid};
        let objRecordInput = {'apiName' : 'Visit__c', fields};
        createRecord(objRecordInput).then(response => {
            alert('Visit created with Id: ' +response.id);
        }).catch(error => {
            alert('Error: ' +JSON.stringify(error));
        });
    }
}