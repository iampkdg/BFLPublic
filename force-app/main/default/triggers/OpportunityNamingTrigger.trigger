trigger OpportunityNamingTrigger on Opportunity (before insert, before delete) {
    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            OpportunityNamingTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
    if(trigger.isDelete)
    {
        OpportunityNamingTriggerHandler.handleBeforeDelete(Trigger.old);
    }
    

}