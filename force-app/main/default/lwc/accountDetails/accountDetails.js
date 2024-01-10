import { LightningElement, api } from 'lwc';
import getAccountById from '@salesforce/apex/AccountController.getAccountById';
import { registerRefreshHandler } from "lightning/refresh";
import {unregisterRefreshHandler} from "lightning/refresh";
import { refreshApex } from '@salesforce/apex';

export default class AccountDetails extends LightningElement {
    @api recordId;
    account;
    nameValue;
    websiteValue;
    ratingValue;
    registerHandlerID;
    nameClass;
    ratingClass;
    showbutton=false;

    connectedCallback()
    {
        this.registerHandlerID= registerRefreshHandler(this, this.refreshHandler);
        this.fetchAccount();
    }

    disconnectedCallback()
    {
         unregisterRefreshHandler(this.registerHandlerID);
    }

    refreshHandler()
    {
        return new Promise(resolve=>{
            this.fetchAccount()
            resolve(true)
        })
    }

    fetchAccount()
    {
        getAccountById({"accountId": this.recordId}).then(response=>{
            console.log(response)
            this.ratingValue=response.Rating
            this.nameValue=response.Name
            this.websiteValue=response.Website
            this.nameClass=this.websiteValue?'green':'red'
            this.ratingClass=this.ratingValue?'green':'red'
            this.websiteClass=this.nameValue?'green':'red'
            if(this.nameClass=='green' && this.ratingClass =='green' && this.websiteClass =='green')
            {
                this.showbutton=true

            }
            else{
                this.showbutton=false
            }

            
            //this.websiteValue=response[0].Website;

        }).catch(error=>{
            console.error(error);
        })
    }


    
}
