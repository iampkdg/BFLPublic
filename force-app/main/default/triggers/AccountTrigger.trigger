trigger AccountTrigger on Account ( before insert, after update, after insert) 
{
    if(trigger.isBefore){
        AccountTriggerHandler.updateRealtedAccountRecords(trigger.new);
    }
    
    
    if(trigger.isUpdate)
    {
        if(trigger.isAfter)
        {
            AccountTriggerHandler.updateRelatedContacts(trigger.new, trigger.oldMap);
            AccountTriggerHandler.insertRealtedContacts(trigger.new);
        }

    }
   else if(trigger.isInsert)
    {
        if(trigger.isAfter)
        {
            AccountTriggerHandler.createRelatedContacts(trigger.new);
        }
    }
    
   
  
    

}