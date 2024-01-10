@isTest
public class BatchClassAccountUpdationTest 
{
    
    @testSetup
    static void Setup()
    {
        List <Account> accList = new List<Account>();
        for(Integer i= 0; i<200; i++)
        {
            Account acc = new Account();
            acc.Name = 'Testing'+i; 
            accList.add(acc);
        }
        insert accList; 
    }

    @isTest
    static void Test()
    {
        Test.startTest();
        BatchClassAccountUpdation myBatch = new BatchClassAccountUpdation();
        ID batchID = Database.executeBatch(myBatch);
        Test.stopTest();   
    }

}