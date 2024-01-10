public with sharing class Grocery {
    // public BFL() {

    // }
    @AuraEnabled(cacheable=true)
    public static  List<Account> getAccountRecords()
    {
        List<Account> acc = new List<Account>();
        System.debug('Number of accounts'+acc.size());
        acc= [select id, name from Account with SECURITY_ENFORCED limit 10 ];
        return acc;
      
    }
    @AuraEnabled(cacheable=true)
    
    public static List<Contact> getContactRecords()
    {
        List<Contact> con= new List<Contact>();
        System.debug('Number of contacts'+con.size());
        con= [select id, name from Contact with SECURITY_ENFORCED limit 10 ];
        return con;
    }
}