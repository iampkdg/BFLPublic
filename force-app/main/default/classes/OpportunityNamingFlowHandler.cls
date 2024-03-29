public with sharing class OpportunityNamingFlowHandler 
{
    @InvocableMethod
    public static void updateOpportunities(List<Opportunities> inputValue)
    {
        List<Opportunity> oppList;
        List<Opportunity> opptoAdd= new List<Opportunity>();
        Integer month;
        Integer year;
        Decimal num=0.0;
        List<Id> oppId= new List<Id>();
        Set<Id> ids= new Set<Id>();
        Opportunity insertNewOpp = new Opportunity();
        
        
        
        //adding up all the ids from invocable variable
        for(Opportunities o: inputValue)
        {
            oppId=o.inputOpportunity;
            ids.addAll(oppId);
        }
        oppList =[Select CloseDate from Opportunity where Id IN: ids];
        
            
        //map to get opportunities
        Map<String, List<opportunity>> monthsVsOppsMap= new Map<String, List<opportunity>>();
        for(Opportunity opp: [SELECT id, Name, MonthCustom__c,Monthly_Sequence_Number__c FROM Opportunity
                              WHERE Monthly_Sequence_Number__c != Null ORDER BY Monthly_Sequence_Number__c DESC])
        {
            if(monthsVsOppsMap.containsKey(opp.MonthCustom__c))
            {
                monthsVsOppsMap.get(opp.MonthCustom__c).add(opp);
            }
            else
            {
                monthsVsOppsMap.put(opp.MonthCustom__c , new List<Opportunity>{opp});
            }
        }
        
        for(Opportunity oppObj: oppList)//--> 3 rec.
        {
            month=oppObj.CloseDate.month();
            year= oppObj.CloseDate.year();
                    
                //for getting the month name from number
            Map<Integer, String> monthMap = new Map<Integer, String>
            {
                1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun',
                7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'
            };
                // Map<Integer,String> monthValMap= new Map<Integer,String>
                // {
                //     1 => '1', 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6',
                //     7 => '7', 8 => '8', 9 => '9', 10 => '10', 11 => '11', 12 => '12'
                // };
                
                //List to get all the opportunities for a month
                //List<Opportunity> checkOppSeqMaxRec= [Select id, Name, MonthCustom__c,Monthly_Sequence_Number__c from Opportunity
                                                                        //Where Monthly_Sequence_Number__c != Null 
                                                                        //AND MonthCustom__c =: monthValMap.get(month)
                                                                        //ORDER BY Monthly_Sequence_Number__c ASC];
            List<Opportunity> checkOppSeqMaxRec = monthsVsOppsMap.get(String.valueOf(month));
            System.debug('checkOppSeqMaxRec--> '+checkOppSeqMaxRec);                
            System.debug('Size of List++++'+checkOppSeqMaxRec.size());
            System.debug('Value of List++++'+checkOppSeqMaxRec.toString());
            if(!checkOppSeqMaxRec.isEmpty())
            {
                    //List to get the max seq number
                    //Opportunity insertNewOpp= [Select Name, Monthly_Sequence_Number__c, MonthCustom__c from Opportunity
                                                //Where Monthly_Sequence_Number__c != Null 
                                                //AND MonthCustom__c =: monthValMap.get(month)
                                                //ORDER BY Monthly_Sequence_Number__c DESC LIMIT 1];
                                                
                insertNewOpp = checkOppSeqMaxRec[0];
                System.debug('insertNewOpp---> '+insertNewOpp);
                Decimal newSeqNum;
                newSeqNum= insertNewOpp.Monthly_Sequence_Number__c++;
                oppObj.Monthly_Sequence_Number__c=insertNewOpp.Monthly_Sequence_Number__c;
                oppObj.MonthCustom__c= insertNewOpp.MonthCustom__c;
                oppObj.Name=year+'-'+monthMap.get(month)+'-'+String.valueOf(oppObj.Monthly_Sequence_Number__c).leftPad(6, '0');
                System.debug(oppObj.Name);
                opptoAdd.add(oppObj);
                
            }
            //update opptoAdd;
        }update opptoAdd;
    }
            
    public class Opportunities
    {
        @InvocableVariable
        public List<Id> inputOpportunity;
    } 
}
