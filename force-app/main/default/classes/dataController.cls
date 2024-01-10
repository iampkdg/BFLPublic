public with sharing class dataController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccList()
        
     {
         return [SELECT Id, Name, AccountNumber,Phone,Type From Account with SECURITY_ENFORCED];

    }
}