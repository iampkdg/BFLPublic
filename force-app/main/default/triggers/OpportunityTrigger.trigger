trigger OpportunityTrigger on Opportunity (after update) 
{
    if(Trigger.isAfter)
    {
        if (Trigger.isUpdate)
        {
            OpportunityTriggerHandler.opportunityFunction( Trigger.oldMap, Trigger.new);
        }
    }
    
}   