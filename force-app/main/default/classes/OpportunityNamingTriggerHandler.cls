public class OpportunityNamingTriggerHandler {
    //Method to add Opportunity Name
    public static void handleBeforeInsert(List<Opportunity> newOpportunities) 
    {
        //Decimal seqNumber = 1;
            Set<String> monthYearKeys = new Set<String>();
            for (Opportunity opp : newOpportunities) {
                Integer year = Date.today().year();
                String month = Datetime.now().format('MMMM').subString(0,3);
                String key = year + '-' + month;
                monthYearKeys.add(key);
            }
        
            // Query to check if the Year and Month data is present in the Opportunity Sequence Object
            Map<String, OpportunityNumberSettings__c> existingSequences = new Map<String, OpportunityNumberSettings__c>();
            for (OpportunityNumberSettings__c sequence : [SELECT Id, NextOpportunityNumber__c, Year__c, Month__c
                                                            FROM OpportunityNumberSettings__c
                                                            WHERE Year__c = :String.valueOf(Date.today().year())
                                                              AND Month__c = :Datetime.now().format('MMMM').subString(0,3)
                                                            ]) 
															{
                existingSequences.put(sequence.Year__c + '-' + sequence.Month__c, sequence);
            }
            System.debug('Existing Sequences: ' + existingSequences);
        
            // Adding sequence numbers and creating new sequences if its not present
            List<OpportunityNumberSettings__c> sequencesToUpdate = new List<OpportunityNumberSettings__c>();
            List<OpportunityNumberSettings__c> sequencesToInsert = new List<OpportunityNumberSettings__c>();
            for (String key : monthYearKeys) 
            {
                OpportunityNumberSettings__c sequence = existingSequences.get(key);
                if (sequence == null)
                {
                    sequence = new OpportunityNumberSettings__c(
                        Year__c = String.valueOf(Date.today().year()),
                        Month__c = Datetime.now().format('MMMM').subString(0,3),    
                        Name = 'Year--'+ String.valueOf(Date.today().year()),
                        NextOpportunityNumber__c = 1
                    );
                    sequencesToInsert.add(sequence);
                } else 
                {
                    //seqNumber++;
                    sequence.NextOpportunityNumber__c++; //= seqNumber;
                    sequencesToUpdate.add(sequence);
                }
            }
        
            // Update 
            System.debug('sequencestoUpdate'+sequencesToUpdate);
            if (!sequencesToUpdate.isEmpty()) {
                try {
                    update sequencesToUpdate;
                } catch (DmlException e) {
                    System.debug('Error updating sequences: ' + e.getMessage());
                }
            }
        
            // Insert 
            if (!sequencesToInsert.isEmpty()) {
                insert sequencesToInsert;
            }


            //refreshing the Map
            existingSequences.clear();
            for (OpportunityNumberSettings__c sequence : [SELECT Id, NextOpportunityNumber__c, Year__c, Month__c
                                                            FROM OpportunityNumberSettings__c
                                                            WHERE Year__c = :String.valueOf(Date.today().year())
                                                              AND Month__c = :Datetime.now().format('MMMM').subString(0,3)
                                                            ]) 
															{
                existingSequences.put(sequence.Year__c + '-' + sequence.Month__c, sequence);
            }
            System.debug('After refresh exsisting sequence'+existingSequences);
        
            // Update opportunity names
            for (Integer i = 0; i < newOpportunities.size(); i++) {
                Opportunity opp = newOpportunities[i];
                String key = Date.today().year() + '-' + Datetime.now().format('MMMM').subString(0,3);
                OpportunityNumberSettings__c sequence = existingSequences.get(key);
                System.debug('Value of next number in sequence'+ sequence.NextOpportunityNumber__c);
                opp.Name = String.valueOf(Date.today().year()) + '-' + Datetime.now().format('MMMM').subString(0,3) + '-' + String.valueOf(sequence.NextOpportunityNumber__c).leftPad(6, '0');
            }
        }
    

    //Method to delete the Sequence Number
    public static void handleBeforeDelete(List<Opportunity> deletedOpportunities) {
        Set<String> monthYearKeys = new Set<String>();
        
        Integer year = Date.today().year();
        String month = Datetime.now().format('MMMM').subString(0,3);
        
        
        for (Opportunity deletedOpp : deletedOpportunities) {	
            String key = year + '-' + month;
            monthYearKeys.add(key);
        }
        
        
        List<Store_Opportunity_Sequence__c> sequencesToUpdate = [SELECT Id, Sequence_Number__c
                                                                 FROM Store_Opportunity_Sequence__c
                                                                 WHERE Year__c = :String.valueOf(year)
                                                                   AND Month__c = :month
                                                                   AND Id IN :monthYearKeys];
        for (Store_Opportunity_Sequence__c sequence : sequencesToUpdate) {
            sequence.Sequence_Number__c--;
        }
        update sequencesToUpdate;
    }
}
