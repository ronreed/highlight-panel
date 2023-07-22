import { LightningElement, api, wire } from 'lwc';
import getFieldResultItems from '@salesforce/apex/HighlightPanelController.getFieldResultItems';
import { getRecord } from "lightning/uiRecordApi";

const FIELDS = ['Id'];

export default class HighlightPanel extends LightningElement {

    @api
    recordId;

    @api
    fieldSetName

    resultItems;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: FIELDS,
      })
      handleRecordData(wireResult) {
        console.log(wireResult);
        this.resultItems = undefined;
        this.refreshFieldResultItems();
    }

    refreshFieldResultItems() {
        getFieldResultItems({ recordId: this.recordId, fieldSetName: this.fieldSetName })
        .then(data => {
            this.resultItems = data;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.resultItems = undefined;
        })
    }

}