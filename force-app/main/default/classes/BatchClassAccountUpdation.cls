public class BatchClassAccountUpdation implements Database.Batchable<sObject> {
    
   // public integer recordsProcessed = 0; 
    public Database.QueryLocator start (Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select ID, Name, Phone, CreatedDate from Account');
    }
    public void execute(Database.BatchableContext bc, List<Account> accList)
    {
        List<Account> accountList = new List<Account>();
        for(Account acc: accList)
        {
              
             acc.Name = acc.Name + 'Testing'; 
            accountList.add(acc);
            //   recordsProcessed = recordsProcessed + 1; 
            
        }
        update accountList;
        
    }
    public void finish (Database.BatchableContext bc)
    {
        //post processing logic 
        //System.debug(recordsProcessed); 
        System.debug('Batch Ran');
    }
}