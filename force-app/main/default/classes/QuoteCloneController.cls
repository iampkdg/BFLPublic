global with sharing class QuoteCloneController {
    @AuraEnabled
    public static Id cloneQuoteWithRelatedLists(Id quoteId) {
        // Retrieve the Quote and its related lists dynamically
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult objResult = gd.get('Quote').getDescribe();
        System.debug('Quote and its Lists ---> '+objResult);

        // Get the list of child relationships for the Quote object
        List<Schema.ChildRelationship> childRelationships = objResult.getChildRelationships();
        System.debug('Child Relationships ---> '+childRelationships);

        // Get the list of objects to be excluded from cloning from Custom Metadata Type(now this is working as list that specifies which related obj to clone)
        Set<String> excludedObjects = new Set<String>();
        for(Exclude_Objects__mdt exclude:[Select ObjectApiName__c from Exclude_Objects__mdt])
        {
            excludedObjects.add(exclude.ObjectApiName__c);
        }

        // Query the Quote and its related list
        // to insert the related lists will have to query all the related list, even if we do dynamic query we will have to still figure out the required fields in all the related objects that are there for each object. 
        Quote originalQuote = [SELECT Id, Name, OpportunityId, Pricebook2Id, IsSyncing,
        (Select Id, Product2Id, PricebookEntryId, TotalPrice, Quantity,
        UnitPrice,Subtotal from QuoteLineItems) 
        FROM Quote WHERE Id = :quoteId LIMIT 1];

        //clone the quote
        Quote clonedQuote = originalQuote.clone(false, true, false, false);
        clonedQuote.Name = 'Cloned - ' + originalQuote.Name;
        System.debug('Cloned Quote Name ----> '+clonedQuote);
        insert clonedQuote;


        //Use map to store the Sobject related rec
        Map<String, List<SObject>> relatedRecordsMap = new Map<String, List<SObject>>();
        for (Schema.ChildRelationship childRel : childRelationships) {
            String childObjectName = childRel.getChildSObject().getDescribe().getName();
            if (excludedObjects.contains(childObjectName)) {
                String relationshipName = childRel.getRelationshipName() != null ? childRel.getRelationshipName() : String.valueOf(childRel.getField());
                List<SObject> relatedRecords = originalQuote.getSObjects(relationshipName);
                relatedRecordsMap.put(relationshipName, relatedRecords);
            }
        }

        

        // Clone and relate the related lists to the cloned Quote dynamically
        for (Schema.ChildRelationship childRel : childRelationships) 
        {
            String childObjectName = childRel.getChildSObject().getDescribe().getName();
            System.debug('Child Obj Name----> '+childObjectName);
            if (excludedObjects.contains(childObjectName)) 
            {
                //continue; // Skip excluded objects
                
                // if(originalQuote.getSObjects(childRel.getRelationshipName()) == null )
                // {
                //     continue;
                // }
                String relationshipName = childRel.getRelationshipName() != null ? childRel.getRelationshipName() : String.valueOf(childRel.getField());
                System.debug('Relationship Name ---> '+relationshipName);

                String fieldName= String.valueOf(childRel.getField());
                System.debug('Field Name ----> '+fieldName);

                List<SObject> relatedList= relatedRecordsMap.get(relationshipName);

                List<SObject> relatedRecords = originalQuote.getSObjects(relationshipName);
                if (relatedRecords != null && !relatedRecords.isEmpty()) 
                {
                    List<SObject> clonedRecords = new List<SObject>();
                    SObject relatedRecord = relatedList[0];
                        SObject clonedRecord = relatedRecord.clone(false, true, false, false);
                        clonedRecord.put(String.valueOf(childRel.getField()), clonedQuote.Id);
                        clonedRecords.add(clonedRecord);
                        System.debug('Cloned Related Records -----> '+clonedRecords);
                    
                    insert clonedRecords;
                }
            }
    }

        // If the original Quote is synced with an Opportunity, unsync it
        if (originalQuote.OpportunityId != null) {
            originalQuote.OpportunityId = null;
            update originalQuote;
        }

        return clonedQuote.Id;
    }
}

