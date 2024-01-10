@isTest
public class OpportuntiyTriggerTest {
    @isTest static void SalesOrderCreation(){
        //Test Data Creation
        Account acc= new Account();
        acc.Name='Seafarer';
        insert acc;
         
        
        
        Opportunity opp = new Opportunity();
        opp.AccountId=acc.id;
        opp.Name=acc.Name+'Test Opportunity';
        opp.StageName='Prospecting';
        opp.CloseDate=date.today();
        //opp.Pricebook2Id =pbe.Pricebook2Id;
        insert opp;
        
        
        
        
        
        Map<Id,Opportunity> newMap= new Map<Id,Opportunity>([Select AccountId, Name, StageName , CloseDate from Opportunity]);
        List<Opportunity> oppList= new List<Opportunity>([Select id, Name, AccountID, StageName, CloseDate from Opportunity]);
        Set<Id> ids= new Set<Id>();
        
        for(Opportunity o: oppList)
        {
            o.StageName ='Closed Won';
            
            ids.add(o.Id);
                
        }
        
        
        
        List<Opportunity> o= [Select Id, AccountId, Name, StageName,CloseDate,Pricebook2Id from Opportunity where id =: ids];
        update o;
        
        List<Sales_Order__c> s=new List<Sales_order__c>();
        	

        for(Opportunity oppL:o)
        {
        System.debug('Line 66'+ oppL.id);
        Sales_Order__c sOrder=new Sales_Order__c();
        sOrder.Account__c = oppL.AccountId;
        sOrder.Name =oppL.Name;
        sOrder.Sales_Order_ExtId__c= oppL.Id;
        s.add(sOrder);
        
        }
        
        List<Database.SaveResult> results=Database.insert(s,false);
        
        Test.startTest();
        OpportunityTriggerHandler.opportunityFunction(newMap,oppList);
        Test.stopTest();
        
        
    }

}