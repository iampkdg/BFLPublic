public with sharing class AccountTriggerHandler {
    
    public static void updateRelatedContacts(List<Account> accList, Map<ID, Account> oldAccMap)
    {
        List<Contact> conList = new List<Contact>();
        Map<Id, Account> accMap = new Map<Id, Account>();
        Set<Id> accId; //for storing the id that is coming from account


        for(Account acc: accList)
        {
            if(acc.Phone != null && acc.Phone != oldAccMap.get(acc.id).Phone && oldAccMap != null)
            {
                accMap.put(acc.Id, acc);
                accId = accMap.keySet(); //for retreiving the id from the Map
                System.debug(accId);

            }

        }
        if(accMap != null)
        {
            for(Contact con: [select id, HomePhone, AccountId from Contact where AccountId IN: accId])
            {
                con.HomePhone = accMap.get(con.AccountId).Phone;
                conList.add(con);
            }    
            }
        if(conList.size()> 0)
        {
            update conList;
        }
    }
    
    
    //2nd trigger logic
    public static void insertRealtedContacts(List<Account> accList)
    {
        Map<Id, Account> accId = new Map<Id, Account>();
        Set<Id> newaccID;
        List<Contact> conList = new List<Contact>();
        for(Account acc: accList)
            {
                
                accId.put(acc.id, acc);
                newaccID = accId.keySet();
            }
            
            if(newaccID != null)
                {
                    for(Contact con: [Select Id, TriggerTest__c, AccountID from Contact where AccountID In: newaccID ])
                    {
                        
                            con.TriggerTest__c = accId.get(con.AccountId).TriggerTest_Acc__c;
                            conList.add(con);
                        
                    }
                }
            
        
        update conList; 
        
    }
    
    //3rd Trigger
    public static void createRelatedContacts(List<Account> accList)
    {
        List<Contact> conList = new List<Contact>();
        
        Contact con = new Contact();
        for(Account acc: accList)
        {
           
                    con.AccountId =acc.id ;
                    con.LastName =  acc.Name;
                    con.Phone = acc.Phone;
                    con.TriggerTest__c = acc.TriggerTest_Acc__c ;
                    conList.add(con);
                      
        }
        
        insert conList;
    }
    
    //4th Trigger
    public static void updateRealtedAccountRecords(List<Account> accList)
    {
 
        for (Account acc : accList)
        {
            if(acc.Industry == 'Media')
            {
                acc.Rating = 'Hot';
            }
                        
        }
        
    }
    
}