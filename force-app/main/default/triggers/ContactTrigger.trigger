trigger ContactTrigger on Contact (after insert) 
{
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            ContactTriggerHandler.ContactTriggerHanlderMethod(Trigger.new);
        }
        
    }
} 