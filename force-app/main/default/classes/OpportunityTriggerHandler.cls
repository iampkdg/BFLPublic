public with sharing class OpportunityTriggerHandler 
{

//opportunity Trigger
public static void opportunityFunction( Map<Id, Opportunity> oldMap, List<Opportunity> newOpportunityList)
{
List<Sales_Order__c> salesOrderList = new List<Sales_Order__c>();// todo --> follow naming convention (salesOrderList)
List<Opportunity> opportunitySortedList= new List<Opportunity>();
List<OpportunityLineItem> oppLineItemSortedList= new List<OpportunityLineItem>();
Set<Id> salesOrderIdSet=new Set<Id>();//todo --> naming convention salesOrderIdSet

for(Opportunity oppObj: newOpportunityList)//isChange checker
  {
      if(oppObj.StageName != oldMap.get(oppObj.id).StageName && oppObj.StageName =='Closed Won')  
       {
      opportunitySortedList.add(oppObj);
 
    }
}
if(!opportunitySortedList.isEmpty())//updation of Sales_order__c
{
for(Opportunity opp: opportunitySortedList)
{
Sales_Order__c salesOrderObj=new Sales_Order__c();// todo --> follow naming convention newSalesOrderObj
salesOrderObj.Name=opp.Name;
salesOrderObj.Account__c = opp.AccountId;
salesOrderObj.Sales_Order_ExtId__c=opp.Id;

salesOrderList.add(salesOrderObj);



}



//todo (use empty check for salesorderlist)
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
// System.debug(salesOrderIdSet);
System.debug(salesOrderIDSet);


//code to send sorted list of Opp Product to OppLineItemTriggerHandler
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

List<OpportunityLineItem> oLIList =[Select Id, OpportunityId, Quantity, UnitPrice, Name, Product2Id from OpportunityLineItem where OpportunityId IN: oIdSet];
System.debug(oLIList);
OpportunityLineItemTriggerHandler.OpportunityLineItemTriggerHandlerMethod(oLIList);

}

else
{
System.debug('----Opportunity Sorted List is Empty----');
}



}

}
