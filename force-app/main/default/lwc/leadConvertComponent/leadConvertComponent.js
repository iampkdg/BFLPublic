import { LightningElement, api, wire, track } from 'lwc';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getData from '@salesforce/apex/Demo.getData';
import convertLead from '@salesforce/apex/Demo.convertLead';
import { refreshApex } from '@salesforce/apex';
//import Lead_Email from "@salesforce/schema/Lead.Email";
import { updateRecord } from 'lightning/uiRecordApi';
import { registerRefreshHandler} from 'lightning/refresh';
import {unregisterRefreshHandler} from "lightning/refresh";


// const FIELDS = [
//     'Lead.Address',
//     'Lead.Company',
//     'Lead.Email',
//     'Lead.Website',
//     'Lead.Is_Identity_document_uploaded__c'
// ];

export default class LeadConvertComponent extends LightningElement {
    @api recordId;
    @track isReadyToConvert = false;
    addressClass;
    companyClass;
    emailClass;
    websiteClass;
    @track identityClass;
    @track colorClass;
    @track lead;
    @track record;
    @track error;
    @track leadRecord; 
    emailData;
    websiteData;
    addressData;
    companyData;
    @track isDocUpdatedData;
    @track isDocUpdatedClass;
    @track showButton = false;
    @track wiredListLeads;
    registerHandlerID;

    connectedCallback()
    {
        this.registerHandlerID= registerRefreshHandler(this, this.refreshHandler)
        this.getLeadData();
    }
    disconnectedCallback()
    {
        unregisterRefreshHandler(this.registerHandlerID);
    }
    refreshHandler()
    {
        console.log('Something Has Changed')
        return new Promise(resolve=>{
            this.getLeadData()
            resolve(true)
        })
    }

    getLeadData()
    {
        getData({"leadID": this.recordId }).then(response=>{
            console.log(response)
            this.emailData=response.Email
            this.companyData=response.Company
            this.addressData=response.Address
            this.websiteData=response.website
            this.companyClass=this.companyData?'green':'red'
            this.emailClass=this.emailData?'green':'red'
            this.addressClass=this.addressData?'green':'red'
            this.websiteClass=this.websiteData?'green':'red'



        }).catch(error=>{
            console.error(error);
        })
    }


    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished(event)
    {
        // Get the list of uploaded files
        let containsIdentity = false;

        const uploadedFiles = event.detail.files;
        alert('No. of files uploaded : ' + uploadedFiles[0].name);
        
        if(uploadedFiles[0].name.toLowerCase().includes('identity')){
            containsIdentity = true;
        }

        if (containsIdentity) {
            // Update the Lead record's Box__c field to true
            const fields = {
                Id: this.recordId,
                Is_Identity_document_uploaded__c: true
            };

            updateRecord({ fields })
                .then(() => {
                    // Record updated successfully
                    // console.log('Hi this is handleclick b4');
                    // this.refreshData();
                    // console.log('Hi this is handleclick');
                })
                .catch(error => {
                    console.error('Error updating lead', error);
                });
        }   
    }

    handleClick()
    {
        console.log('this.recordId==> ',this.recordId);
        convertLead({ leadId: this.recordId })
       .then(result => {
               console.log('converted ');
       })
       .catch(error => {
           console.log('Errorured:- '+error.body.message);
       });
    }

}
