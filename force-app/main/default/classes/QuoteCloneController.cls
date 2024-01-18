public with sharing class QuoteCloneController {
    @AuraEnabled
    public static void cloneQuoteWithRelatedLists(Id quoteId) {

        // Retrieve the Quote and its related lists
        Quote clonedQuote;
        Quote originalQuote = [SELECT Id, Name, OpportunityId, Pricebook2Id, IsSyncing FROM Quote WHERE Id = :quoteId LIMIT 1];
        List<QuoteLineItem> originalQuoteLineItems = [SELECT Id, Product2Id, PricebookEntryId, TotalPrice, Quantity,
        UnitPrice,Subtotal FROM QuoteLineItem WHERE QuoteId = :quoteId];
        List<QuoteDocument> orignalQuoteDocument = [SELECT Id, Name, IsDeleted from QuoteDocument WHERE QuoteId =: quoteId]; 
        
        //Retrieving the Custom Metadata
        Set<String> excludeObjects= new Set<String>();
        for(Exclude_Objects__mdt exclude:[Select ObjectApiName__c from Exclude_Objects__mdt])
        {
            excludeObjects.add(exclude.ObjectApiName__c);
        }
        

        //Clone the quote
        if(originalQuote.OpportunityId!=Null)
        {
        originalQuote.OpportunityId= null;
        clonedQuote = originalQuote.clone(false,true, false, false);
        clonedQuote.Name = 'Cloned - ' + originalQuote.Name;
        insert clonedQuote;
        }
        else{
        clonedQuote = originalQuote.clone(false,true, false, false);
        clonedQuote.Name = 'Cloned - ' + originalQuote.Name;
        insert clonedQuote;
        }
        

        //Clone and relate the related lists to the cloned Quote
        List<QuoteLineItem> clonedQuoteLineItems = new List<QuoteLineItem>();
        for (QuoteLineItem item : originalQuoteLineItems) 
        {
            QuoteLineItem clonedItem = item.clone(false, false, false, false);
            clonedItem.QuoteId = clonedQuote.Id;
            clonedQuoteLineItems.add(clonedItem);
        }
        insert clonedQuoteLineItems;
        
        List<QuoteDocument> clonedQuoteDocument= new List<QuoteDocument>();
        for(QuoteDocument doc:orignalQuoteDocument)
        {
            if(!excludeObjects.contains('QuoteDocument'))// check the custom metadata for the related list type
            {
            QuoteDocument clonedDoc = doc.clone(false, false, false, false);
            clonedDoc.QuoteId= clonedQuote.Id;
            clonedQuoteDocument.add(clonedDoc);
            }
        }
        insert clonedQuoteDocument;
        
    }
}