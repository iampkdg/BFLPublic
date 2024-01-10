public class Demo {
    @AuraEnabled
    public static Lead getLeadData(Id leadID){
        Lead leadList= [select ID, Email,Website, Address, Company, Is_Identity_Document_Uploaded__c from Lead where id =: leadID];
        return leadList; 
    }
 
    @AuraEnabled
    public static Id convertLead(Id leadId){
        Lead myLead = [SELECT Id,Company,LastName FROM Lead WHERE Id=: leadId];
        System.debug('leadID==> '+ leadId);
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        Id accountId =[select id, ConvertedAccountId from lead where id =: leadId].ConvertedAccountId;
        return accountId;
    }

}