public with sharing class Sep9Cls2
{
    @AuraEnabled(cacheable = true)
    public static List<Sep9__c> getAllDetails()
        {
            List<Sep9__c> ls=[SELECT Sno__c,Name,Email__c,Id FROM Sep9__c WITH SECURITY_ENFORCED];
            return ls;
        }
    @AuraEnabled
        public static Id saveDetails(Integer mySno, String myName, String myEmail)
        {
            Sep9__c s=new Sep9__c();
            s.Sno__c=mySno;
            s.Name=myName;
            s.Email__c=myEmail;
            insert s;
            return s.Id;

        }
}