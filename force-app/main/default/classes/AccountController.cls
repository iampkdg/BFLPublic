public with sharing class AccountController {
    @AuraEnabled
    public static Account getAccountById(Id accountId) {
        return [SELECT Id, Rating,Name, Website  FROM Account WHERE Id = :accountId];
    }
}
 