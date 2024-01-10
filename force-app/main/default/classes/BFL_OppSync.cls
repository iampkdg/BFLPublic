public class BFL_OppSync {

    Opportunity Opp = [Select id , Name, AccountId , StageName from Opportunity where StageName IN ('Closed Won')];
    
}