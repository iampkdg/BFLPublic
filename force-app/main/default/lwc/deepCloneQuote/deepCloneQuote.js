import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import cloneQuoteWithRelatedLists from '@salesforce/apex/QuoteCloneController.cloneQuoteWithRelatedLists';

export default class DeepCloneQuote extends NavigationMixin(LightningElement) {
    _recordId;
    navigateQuoteId;


    //used for quick action. 
    @api get recordId(){
        return this._recordId;
    }
    set recordId(recordId){
        if (recordId !== this._recordId) {
            this._recordId = recordId;
       }
    }


    //used for headless quick action need to implement invoke
    @api async invoke(){
        this.handleDeepClone();
    }
     handleDeepClone() 
    {
        console.log('Quick Action Button Clicked');
        cloneQuoteWithRelatedLists({quoteId: this.recordId})
        .then(result =>{
            console.log('Id---> '+result);
            const reId = result;
                console.log('Id is ---> '+reId);
                this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: reId,
                                actionName: 'view'
                            }
                        });


        }).catch(error =>{
            console.error('Error cloning quote: ', error);
        })    
    }
}
