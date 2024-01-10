public with sharing class Pagi {
    @AuraEnabled(cacheable=true)
    public static List<Account> getContactDetails()
    {
        return [SELECT Id, Name FROM Account with SECURITY_ENFORCED];
    }
}