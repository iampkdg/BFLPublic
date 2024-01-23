global with sharing class QuoteCloneController 
{
    @AuraEnabled
    public static Id cloneQuoteWithRelatedLists(Id quoteId) 
    {

        List<SObject> clonedRecords = new List<SObject>();
        
        // Retrieve the Quote
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult objResult = gd.get('Quote').getDescribe();
        System.debug('Quote and its Lists ---> '+objResult);

        // Get the list of objects to be excluded from cloning from Custom Metadata Type(now this is working as list that specifies which related obj to clone)
        Set<String> excludedObjects = new Set<String>();
        for(Exclude_Objects__mdt exclude:[Select ObjectApiName__c from Exclude_Objects__mdt])
        {
            excludedObjects.add(exclude.ObjectApiName__c);
        }
        System.debug('OBJECTS are ---> '+excludedObjects);

        // Query the Quote
        Quote originalQuote = [SELECT Id, Name, OpportunityId, Pricebook2Id, IsSyncing FROM Quote WHERE Id = :quoteId LIMIT 1];
        
        //clone the quote
        Quote clonedQuote = originalQuote.clone(false, true, false, false);
        clonedQuote.Name = 'Cloned - ' + originalQuote.Name;
        insert clonedQuote;
        System.debug('Cloned Quote Name ----> '+clonedQuote);

        // Get the list of child relationships for the Quote object
        List<Schema.ChildRelationship> childRelationships = objResult.getChildRelationships();
        System.debug('Child Relationships ---> '+childRelationships);

        // Clone and relate the related lists to the cloned Quote dynamically
        for (Schema.ChildRelationship childRelationship : childRelationships) 
            {
                Schema.DescribeSObjectResult childObjectDescribe = childRelationship.getChildSObject().getDescribe();
               
                // Check if the child object is one of the specified child objects
                if (excludedObjects.contains(childObjectDescribe.getName())) 
                {
                continue;
                }
                String relationshipName;

                if(childObjectDescribe.isQueryable() && childObjectDescribe.isCreateable())//filter for if queryable and creatable
                {
                    if(childRelationship.getField().getDescribe().isFilterable())//filter for field check if filterable
                    {
                    // Get the required fields for the child object
                    List<String> requiredFields = new List<String>();
                    for (Schema.SObjectField childField : childObjectDescribe.fields.getMap().values()) 
                    {
                        Schema.DescribeFieldResult childFieldDescribe = childField.getDescribe();
                        if (childFieldDescribe.getType() == Schema.DisplayType.REFERENCE || (!childFieldDescribe.isNillable() && !childFieldDescribe.isDefaultedOnCreate()))
                        {
                            requiredFields.add(childFieldDescribe.getName());
                                
                        }
                    }
                    System.debug('Required Fields -----> '+requiredFields);

                    //get the child rec field name for query
                    relationshipName= String.valueOf(childRelationship.getField());
                    
                    //Build the dynamic query
                    String queryFields = String.join(requiredFields, ',');
                    String quotesId= originalQuote.Id;
                    String queryString = 'SELECT ' + queryFields + ' FROM ' + childObjectDescribe.getName() + ' WHERE '+ relationshipName+ ' =: quotesId';
                    System.debug('The Dynamic Query Is ----> '+queryString);
                    
                    
                    // Clone and relate the child objects to the cloned Quote
                    List<SObject> relatedObjects = Database.query(queryString);
                    List<SObject> clonedRelatedObjects = new List<SObject>();
                    for (SObject relatedObject : relatedObjects) 
                    {
                        SObject clonedRelatedObject = relatedObject.clone(false, true, false, false);
                        clonedRelatedObject.put('QuoteId', clonedQuote.Id);
                        clonedRelatedObjects.add(clonedRelatedObject);
                    }
                    
                    // Insert the cloned related objects and check for the error
                    Database.SaveResult[] relatedSrList = Database.insert(clonedRelatedObjects, false);
                    for (Database.SaveResult relatedSr : relatedSrList) 
                    {
                        if (relatedSr.isSuccess()) 
                        {
                            System.debug('Cloned ' + childObjectDescribe.getName() + ' Id: ' + relatedSr.getId());
                        }
                        else
                        {
                            for (Database.Error error : relatedSr.getErrors()) 
                            {
                                System.debug('Error creating ' + childObjectDescribe.getName() + ': ' + error.getStatusCode() + ': ' + error.getMessage());
                            }
                        }
                    }
                }
            }
        }
        return clonedQuote.Id;
    }
}