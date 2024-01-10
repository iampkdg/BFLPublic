import { LightningElement, api } from 'lwc';
import getLeadData from '@salesforce/apex/Demo.getLeadData';
import {registerRefreshHandler, unregisterRefreshHandler} from "lightning/refresh";
import { updateRecord } from 'lightning/uiRecordApi';
import convertLead from '@salesforce/apex/Demo.convertLead';
import { NavigationMixin } from 'lightning/navigation';

export default class LeadConversion extends NavigationMixin(LightningElement) {
    @api recordId
    emailValue
    addressValue
    websiteValue
    companyValue
    documentValue
    emailClass
    addressClass
    websiteClass
    companyClass
    documentClass
    showbutton = false;
    registerHandlerId;

    connectedCallback()
    {
        this.registerHandlerId=registerRefreshHandler(this, this.refreshHandler);
        this.fetchLead();

    }
    disconnectedCallback()
    {
        unregisterRefreshHandler(this.registerHandlerId);
    }

    refreshHandler()
    {
        return new Promise(resolve=>{
            this.fetchLead()
            resolve(true)
        })

    }

    fetchLead()
    {
        getLeadData({"leadID":this.recordId}).then(response=>{
            this.emailValue=response.Email
            this.addressValue=response.Address
            this.websiteValue=response.Website
            this.companyValue=response.Company
            this.documentValue=response.Is_Identity_document_uploaded__c
            this.emailClass=this.emailValue?'green':'red'
            this.addressClass=this.addressValue?'green':'red'
            this.websiteClass=this.websiteValue?'green':'red'
            this.companyClass=this.companyValue?'green':'red'
            this.documentClass=this.documentValue?'green':'red'
            if(this.emailClass=='green' && this.addressClass =='green' && this.websiteClass =='green' && this.companyClass =='green' && this.documentClass == 'green')
            {
                this.showbutton=true
            }
            else{
                this.showbutton=false
            }
            // afterUpload(this.eventValue)
            // {
            //     console.log('Hi Inside after upload')
            //     // Get the list of uploaded files
            //     let containsIdentity = false;

            //     const uploadedFiles = this.eventValue
            //     alert('No. of files uploaded : ' + uploadedFiles[0].name);
                
            //     if(uploadedFiles[0].name.toLowerCase().includes('identity'))
            //     {
            //         containsIdentity = true;
            //     }

            //     if (containsIdentity) 
            //     {
            //         // Update the Lead record's Box__c field to true
            //         const fields = {
            //             Id: this.recordId,
            //             Is_Identity_document_uploaded__c: true
            //         };

            //         updateRecord({ fields })
            //             .then(() => {
            //                 console.log('Hi this is handleclick b4');
            //                 this.documentValue = fields.Is_Identity_document_uploaded__c;
            //                 this.documentClass=this.documentValue?'green':'red';
            //                 if(this.emailClass=='green' && this.addressClass =='green' && this.websiteClass =='green' && this.companyClass =='green' && this.documentClass == 'green')
            //                     {
            //                         this.showbutton=true
            //                     }
            //                     else{
            //                         this.showbutton=false
            //                     }
            //                 console.log('HI this is docVal'+this.docVal);
                            
            //             })
            //             .catch(error => {
            //                 console.error('Error updating lead', error);
            //             });
            //     }  
            // }
         }).catch(error=>{
            console.error(error)
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
        
        if(uploadedFiles[0].name.toLowerCase().includes('identity'))
        {
            containsIdentity = true;
        }

        if (containsIdentity) 
        {
            // Update the Lead record's Box__c field to true
            const fields = {
                Id: this.recordId,
                Is_Identity_document_uploaded__c: true
            };

            updateRecord({ fields })
                .then(() => {
                     this.docVal = fields.Is_Identity_document_uploaded__c;
                     this.documentClass=this.docVal?'green':'red';
                     if(this.emailClass=='green' && this.addressClass =='green' && this.websiteClass =='green' && this.companyClass =='green' && this.documentClass == 'green')
                        {
                            this.showbutton=true
                        }
                        else{
                            this.showbutton=false
                        }
                    
                })
                .catch(error => {
                    console.error('Error updating lead', error);
                });
        }  
    }
    // handleUploadFinished(event)
    // {
    //     this.eventValue= event.details.value;
    //     this.fetchLead()
    //     console.log('Hi after fetchLead called from handleUploadFinished')
    // }
    

    handleClick()
    {
    //     console.log('this.recordId==> ',this.recordId);
    //     convertLead({ leadId: this.recordId })
    //    .then(result => {
    //     alert('Lead Converted to Account, Contact and Opportunity');
    //     //console.log('After button click');
    //     console.log(result);
    //     this.redirectToAccount();
    //    })
    //    .catch(error => {
    //        console.log('Error in Conversion:- '+error.body.message);
    //    });

        convertLead({leadId: this.recordId})
        .then(accountId=>{
            if(accountId)
            {
                console.log('Entered in accountId');
                alert('Lead Converted to Account, Contact and Opportunity. Click OK to redirect to the Account');
                this.redirectToAccount(accountId);
            }

        })
        .catch(error=>{
            console.log('Error in Conversion'+error.body.message);
        })
    }

    redirectToAccount(accountId)
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            },
        });

    }

}
