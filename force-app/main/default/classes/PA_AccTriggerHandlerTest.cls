@IsTest
public with sharing class PA_AccTriggerHandlerTest 
{
    @istest
   
    public static void newAccInsert() 
    {
        List<Account> accList=new List<Account>();
        for(integer i=0;i<2;i++)
        {
            Account acc=new Account();
            acc.Name='Pankaj'+i;
            acc.PA_Office_Country__c='Dakota';
            accList.add(acc);
            
        }
        
        test.startTest();
        insert accList;
        test.stopTest();




    } 
    
    @istest
    
    public static void updateAccTest()
    {
        Contact con=new Contact();
        List<Account> accList=new List<Account>();
        for(integer i=0;i<1;i++)
        {
            Account acc=new Account();
            acc.Name='pankaj';
            acc.PA_Office_Country__c='rajasthan';
            
            accList.add(acc);
        }
        test.startTest();
        insert accList; 
        
        List<Account> accOldList=new List<Account>();
        Account accOld= new Account();
        accOld.Name='pankaj';
        accOldList.add(accOld);
        
        if(accList == accOldList)
        {
            System.debug('Hello');
            update accList;
        }
        test.stopTest();
    }
}