public with sharing class Store {
    @AuraEnabled(cacheable=true)
    public static  List<Account> getAccountRecords()
    {
       
        List<Account> acc= [select id, name, phone from Account with SECURITY_ENFORCED limit 10 ];
        return acc;
        
      
    }
    @AuraEnabled(cacheable=true)
    
    public static List<Contact> getContactRecords()
    {
        List<Contact> con= new List<Contact>();
        System.debug('Number of contacts'+con.size());
        con= [select id, name, Email from Contact with SECURITY_ENFORCED limit 20];
        return con;
    }

}