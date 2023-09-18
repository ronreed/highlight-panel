import { LightningElement, api, wire } from 'lwc';
import getFieldResultItems from '@salesforce/apex/HighlightPanelController.getFieldResultItems';
import { getRecord } from "lightning/uiRecordApi";

const FIELDS = ['Id'];

export default class HighlightPanel extends LightningElement {

    @api
    recordId;

    @api
    fieldSetName

    @api
    disableStickyMode

    @api
    highlightsPanelAboveContainer

    @api
    higlightsPanelCompactViewEnabled
    
    resultItems;
    isLoaded = false;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: FIELDS,
      })
      handleRecordData(wireResult) {
        this.resultItems = undefined;
        this.refreshFieldResultItems();
    }

    refreshFieldResultItems() {
        getFieldResultItems({ recordId: this.recordId, fieldSetName: this.fieldSetName })
        .then(data => {
            if (data?.length) {
                this.resultItems = data;
                this.error = undefined;
                this.isLoaded = true;
            }
        })
        .catch(error => {
            this.error = error;
            this.resultItems = undefined;
            this.isLoaded = true;
        })
    }

}