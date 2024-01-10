trigger OpportunityLineItemTrigger on OpportunityLineItem ( after update) 
{
if(Trigger.isAfter)
    {
    
        if (Trigger.isUpdate)
        {
            System.debug('Line 6');
            OpportunityLineItemTriggerHandler.OpportunityLineItemTriggerHandlerMethod(trigger.new);
        }
    
}
}