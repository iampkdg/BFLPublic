public with sharing class OpportunityNamingFlowHandler {

@InvocableMethod
public static void updateOpportunities(List<Opportunities> inputValue)
{
    List<Opportunity> oppList;
    List<Id> opportunities;
    List<Opportunity> opptoAdd= new List<Opportunity>();
    List<Opportunity> oppUpdate= new List<Opportunity>();
    
    
    Integer month;
    Integer year;
    Decimal num=0.0;
    List<Id> oppId= new List<Id>();
    Set<Id> ids= new Set<Id>();
    Set<Integer> monthSet = new Set<Integer>();
    
    
    
    //should be inside a for to handle multiple values
    for(Opportunities o: inputValue)
    {
        oppId=o.inputOpportunity;
        ids.addAll(oppId);
    }
        System.debug('oppId+++++'+ids);
        oppList =[Select CloseDate from Opportunity where Id IN: ids];
        System.debug('Hi++++'+oppList.size());
    
            Set<Integer> dateCheck= new Set<Integer>();
            for(Opportunity oppObj: oppList)
            {
                month=oppObj.CloseDate.month();
                year= oppObj.CloseDate.year();
                System.debug('Hi++'+year+'-'+month);
            
                System.debug('Month+++'+dateCheck);
                
            
            
            //for getting the month name from number
            Map<Integer, String> monthMap = new Map<Integer, String>
                            {
                                1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun',
                                7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'
                            };
                Map<Integer,String> monthValMap= new Map<Integer,String>{
                                    1 => '1', 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6',
                                7 => '7', 8 => '8', 9 => '9', 10 => '10', 11 => '11', 12 => '12'
                                };
                
                //Map to get all Opportunities                       
            //Map<String , List<Opportunity>> monthsVsOppsMap = new Map<String , List<Opportunity>>();
    /*for(Opportunity opp: [SELECT id, Name, MonthCustom__c,Monthly_Sequence_Number__c FROM Opportunity])
    {
        if(monthsVsOppsMap.containsKey(opp.MonthCustom__c))
        {
            monthsVsOppsMap.get(opp.MonthCustom__c).add(opp);
        }else
        {
            monthsVsOppsMap.put(opp.MonthCustom__c , new List<Opportunity>{opp});
        }
    }*/
    //System.debug('monthsVsOppsMap==> ' + monthsVsOppsMap);
                                
                            //Opportunity oppObj= new Opportunity();
                            
            

    
            //List to get all the opportunities for a month
            List<Opportunity> checkOppSeqMaxRec= [Select id, Name, MonthCustom__c,Monthly_Sequence_Number__c from Opportunity
                                                                    Where Monthly_Sequence_Number__c != Null 
                                                                    AND MonthCustom__c =: monthValMap.get(month)
                                                                    ORDER BY Monthly_Sequence_Number__c ASC];
            //List<Opportunity> checkOppSeqMaxRec = monthsVsOppsMap.get(opp.MonthCustom__c);
            
            System.debug('Size of List++++'+checkOppSeqMaxRec.size());
            System.debug('Value of List++++'+checkOppSeqMaxRec.toString());
            if(!checkOppSeqMaxRec.isEmpty())
            {
                //List to get the max seq number
                Opportunity insertNewOpp= [Select Name, Monthly_Sequence_Number__c, MonthCustom__c from Opportunity
                                            Where Monthly_Sequence_Number__c != Null 
                                            AND MonthCustom__c =: monthValMap.get(month)
                                            ORDER BY Monthly_Sequence_Number__c DESC LIMIT 1];
                
                    Decimal newSeqNum;
                    newSeqNum= insertNewOpp.Monthly_Sequence_Number__c++;
                    oppObj.Monthly_Sequence_Number__c=insertNewOpp.Monthly_Sequence_Number__c;
                    oppObj.MonthCustom__c= insertNewOpp.MonthCustom__c;
                    oppObj.Name=year+'-'+month+'-'+String.valueOf(oppObj.Monthly_Sequence_Number__c).leftPad(6, '0');
                    System.debug(oppObj.Name);
                    opptoAdd.add(oppObj);
                
                
            }
                update opptoAdd;
            }
            
}


    

public class Opportunities{
    @InvocableVariable
    public List<Id> inputOpportunity;
}
}