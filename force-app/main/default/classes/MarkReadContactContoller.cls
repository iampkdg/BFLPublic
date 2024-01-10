public with sharing class MarkReadContactContoller 
{

    public static ApexPages.StandardSetController setCon;
    public List<Contact> conList{get;set;}
    public Map<Id, Contact> conMap{get;set;}
    public List<Contact> conUpdateList{get;set;}
    public List<Contact> retConUpdateList{get;set;}
    public Set<Id> updateConIDSet{get;set;}
    
    public MarkReadContactContoller(ApexPages.StandardsetController stdController) 
    {
        setCon= stdController;
        conList=(List<Contact>)stdController.getSelected();
        //conMap.putAll(conList);
        conMap = new Map<Id, Contact>();
            for (Contact c : conList) {
                conMap.put(c.Id, c);
            }
    }
    
    public PageReference markAsRead()
    {
        Integer count= 0;
        List<Contact> conFliteredList= [Select id, Is_Contact_mark__c from Contact where ID =: conMap.keySet()];
        conUpdateList= new List<Contact>();
        System.debug(conList);
        System.debug(conList.size());
        if(conFliteredList.size()>0)
        {
            for(Contact con: conFliteredList)
                {
                    if(con.Is_Contact_Mark__c == false)
                {
                con.Is_Contact_Mark__c = true;
                conUpdateList.add(con);
                count++;
                }
            }
        }
        System.debug(count);
        //update conUpdateList;
        //add check for empty
        if(conUpdateList.size()>0)
        {
            List<Database.SaveResult> saveResult= Database.update(conUpdateList, false);
            updateConIDSet = new Set<Id>();
            if(saveResult.size()>0)
            {
                for(Database.SaveResult sr: saveResult)
                {
                    if(sr.isSuccess())
                    {
                        updateConIDSet.add(sr.getId());
                    }
                    else 
                    {
                        for(Database.Error err :sr.getErrors())
                        {
                            System.debug('Error has occured'+err.getMessage()+'---'+err.getStatusCode()+'-----'+err.getFields());
                        }
                    }
                }
            }

        }
        

        PageReference contactListView = new PageReference('/lightning/o/Contact/list');
        contactListView.setRedirect(true);
        return contactListView;
    }
}