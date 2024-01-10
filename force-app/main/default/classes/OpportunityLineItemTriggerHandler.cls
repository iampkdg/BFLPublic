public with sharing class OpportunityLineItemTriggerHandler 
{
    public static void OpportunityLineItemTriggerHandlerMethod (List<OpportunityLineItem> lineItemList)  
    {
    
        
        //List<OpportunityLineItem> opLineItemNewList= new List<OpportunityLineItem>();
        Set<Id> opLineItemIdSet=new Set<Id>();
        for(OpportunityLineItem opLineItemObj: lineItemList)
        {
            opLineItemIdSet.add(opLineItemObj.OpportunityID);
        }
        System.debug(opLineItemIDSet);

        List<Opportunity> oppList= [select id, AccountId, Name, StageName from Opportunity where id IN: opLineItemIdSet];
        Set<Id> opIdSet= new Set<Id>();
        for(Opportunity oppObj: oppList)
        {
            opIdSet.add(oppObj.AccountId);
        }
        System.debug(opIdSet);

        List<Sales_order__c> salesOrderList= [Select id, Account__c, Sales_order_ExtId__c from Sales_Order__C where Account__c IN: opIdSet];
        Set<Id> salesOrderIdSet= new Set<Id>();
        for(Sales_Order__c sOrderObj : salesOrderList)
        {
            salesOrderIdSet.add(sOrderObj.id);
        }
        System.debug(salesOrderIdSet);
        
        List<Sales_order_line__c> salesOrderLineList= new List<Sales_order_line__c>();
        if(!salesOrderIdSet.isEmpty())
        {
            System.debug('Not Empty');
            for(Sales_Order__c sObj: salesOrderList)
            {
                
                for(OpportunityLineItem opLineItemObj: lineItemList)
                {
                    Sales_Order_Line__c sOrderLineObj= new Sales_Order_Line__c();
                    sOrderLineObj.Qty__c= opLineItemObj.Quantity;
                    sOrderLineObj.Currency__c=opLineItemObj.UnitPrice;
                    sOrderLineObj.Name=opLineItemObj.Name;
                    sOrderLineObj.Sales_Order_Line_Item_ExtId__c=opLineItemObj.id;
                    sOrderLineObj.Sales_Order__C=sObj.id;
                    salesOrderLineList.add(sOrderLineObj);
                }
            }
        }



        if(!salesOrderLineList.isEmpty())
        {
            List<Database.UpsertResult> upsertedData= Database.upsert(salesOrderLineList, Sales_Order_Line__c.Fields.Sales_Order_Line_Item_ExtId__c, false);
            for(Database.UpsertResult sr: upsertedData)
            {
                if(sr.isSuccess())
                {
                    System.debug('Success, SalesOrderLineId ----> '+sr.getId());
                }
                else 
                {
                    for(Database.Error err:sr.getErrors())
                    {
                        System.debug('Error has'+err.getMessage()+'-------'+err.getStatusCode());
                        System.debug('Error in fields'+err.getFields());
                    }
                    
                }
            }
        }
    }
}
