@isTest
public class AccountTriggerHandlerTest {
    @isTest
    public static void createRelatedContactsTest()
    {
        
        List<Account> accList = new List<Account>();
        for(integer i=0 ; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'TestClassPankaj'; 
            acc.Phone='908287474';
            acc.TriggerTest_Acc__c ='Hi this is from the Test class';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
    }

}