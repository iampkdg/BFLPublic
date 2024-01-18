import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cloneQuoteWithRelatedLists from '@salesforce/apex/QuoteCloneController.cloneQuoteWithRelatedLists';


export default class DeepCloneQuoteButton extends LightningElement {
    @api recordId
    handleDeepClone() {
        console.log('Button Clicked');
        cloneQuoteWithRelatedLists({ quoteId: this.recordId })
            .then(result => {
                // Handle success
                //console.log('Quote cloned successfully: ', result);
                const event= new ShowToastEvent({
                    title: 'Quote Cloned',
                    message:'The Selected Quote is Cloned',
                    variant: 'success'
                });
                this.dispatchEvent(event);
            })
            .catch(error => {
                // Handle error
                console.error('Error cloning quote: ', error);
            });
    }
}
