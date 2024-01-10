public class BFL_SalesOrderLineSync { 
    
    @InvocableMethod
    public static List<Sales_Order_Line__c> salesOrderLine(List<InputVariables> inputVariables)
    {
        List<OpportunityLineItem> oppId = inputVariables.get(0).opportunityLineItem;
        Set<Id> opLineItemIdSet=new Set<Id>();
        for(OpportunityLineItem oppLineItem: oppID)
        {
            opLineItemIdSet.add(oppLineItem.OpportunityID);

        }
        System.debug(opLineItemIdSet);

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
                
                for(OpportunityLineItem opLineItemObj: oppId)
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

        // System.debug('Line 7 oppID'+oppId); 
        // List<OpportunityLineItem> oppLineItem=[Select id, OpportunityId,Quantity,
        //                                        ListPrice, UnitPrice, Product2Id  from OpportunityLineItem where id =: oppId];
        // List<Opportunity> opId=[Select ID, AccountId from Opportunity where StageName='Closed Won'];
        // List<Sales_Order__c> salesOrder=[select Id, Account__c from Sales_Order__c];  
        // List<Sales_Order_Line__c> salesOrderLine= new List<Sales_Order_Line__C>();
        // for(Opportunity o:opId)
        // {
        //     for(Sales_Order__c so: salesOrder)
        //     {
        //         if(o.AccountId == so.Account__c)
        //         {
        //             System.debug('ID Matched'+o.AccountId);
        //             for(OpportunityLineItem ol: oppLineItem)
        //             {
        //                 if(ol.OpportunityId == o.Id)
        //                 {
        //                     Sales_Order_Line__c sorder= new Sales_Order_Line__c(Sales_Order_Line_Item_ExtId__c = ol.id,
        //                                                                         Qty__c= ol.Quantity,
        //                                                                         Currency__c=ol.UnitPrice,
        //                                                                         Product__c=ol.Product2Id,
        //                                                                         Sales_Order__c=so.Account__c);
        //                     salesOrderLine.add(sorder);
        //                 }
        //             }
        //         }
        //     }
        // }
        try
        {
            
            upsert salesOrderLineList Sales_Order_Line_Item_ExtId__c;
        }
        catch(DMLException e)
        {
            System.debug('Error++'+e.getMessage());
            
        }
        return salesOrderLineList ;
        
    }
    
    public class InputVariables
    {
        @InvocableVariable(label='Get Opportunity Line Item Id from Flow')
        public List<OpportunityLineItem> opportunityLineItem;//id is stored 0065g00000ZjvcoAAB
    }
    
}