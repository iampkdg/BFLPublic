public class BFL_SalesOrderSync 
{
    @InvocableMethod
    public static List<Sales_Order__c> salesOrder(List<InputVariables> input)
    {
        List<Opportunity> oppId = input.get(0).getOpportunityId;
        List<Opportunity> oppList =[Select Id, Name, AccountID from Opportunity WHERE Id in: oppId ];
        Sales_Order__c[] salesOrder=new Sales_Order__c[]{};
        List<Sales_Order__c> salesOrderList = new List<Sales_Order__c>();
        Set<Id> salesOrderIdSet= new Set<Id>();
            
            if(oppList.size()>0)
        {
            for(Opportunity opp: oppList)
            {
                Sales_Order__c sOrder=new Sales_Order__c();
                sOrder.Name= opp.Name;
                sOrder.Sales_Order_ExtId__c= opp.Id;
                sOrder.Account__c= opp.AccountID;
                
                salesOrderList.add(sOrder);
            }
            
        }
        
        // try{
        //     upsert salesOrder Sales_Order_ExtId__c;
        // }
        // catch(DmlException e)
        // {
        //     System.debug('Error++'+ e.getMessage());
        // }
        // return salesOrder;
        //
        if(!salesOrderList.isEmpty())
        {
            List<Database.UpsertResult> upsertedData = Database.upsert(salesOrderList,Sales_Order__c.Fields.Sales_Order_ExtId__c,false);//false-->all or none

            for(Database.UpsertResult sr:upsertedData)
            {
                if(sr.isSuccess())
                {
                    salesOrderIdSet.add(sr.getId());
                    System.debug('Upserted record Id'+salesOrderIdSet);
                    

                }
                
                else {
                    for(Database.Error err :sr.getErrors())
                    {
                        System.debug('Error has occured'+err.getMessage()+'---'+err.getStatusCode());
                        System.debug('Error in Field'+err.getFields());

                    }

                }
                
            }

        }
        List<BFL_SalesOrderLineSync.InputVariables> inputForLineSync = new List<BFL_SalesOrderLineSync.InputVariables>();
        BFL_SalesOrderLineSync.InputVariables lineSyncInput = new BFL_SalesOrderLineSync.InputVariables();

        List<Sales_Order__c> sOrderList= [Select id, Name, Account__c from Sales_Order__c where id IN: salesOrderIdSet];
        Set<Id> sIDSet = new Set<Id>();
        for(Sales_order__c sOrderObj: sOrderList)
        {
            sIdSet.add(sOrderObj.Account__c);
        }
        System.debug(sIDSet);

        List<Opportunity> oList=[Select id, AccountId ,StageName, Name from Opportunity where AccountId IN: sIDSet];
        Set<Id> oIdSet= new Set<Id>();
        for(Opportunity oppObj: oList)
        {
            oIdSet.add(oppObj.id);
            System.debug(oppObj.StageName);

        }
        System.debug(oIdSet);
        //List<OpportunityLineItem> oLIList= new List<OpportunityLineItem>();

        lineSyncInput.opportunityLineItem =[Select Id, OpportunityId, Quantity, UnitPrice, Name, Product2Id from OpportunityLineItem where OpportunityId IN: oIdSet];
        inputForLineSync.add(lineSyncInput);
        //System.debug(oLIList);

        List<Sales_Order_Line__c> salesOrderLines = BFL_SalesOrderLineSync.salesOrderLine(inputForLineSync);



        return salesOrderList;
    }
    
    public class InputVariables
    {
        @InvocableVariable
        public List<Opportunity> getOpportunityId;
    }

}