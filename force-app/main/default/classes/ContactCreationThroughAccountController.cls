public with sharing class ContactCreationThroughAccountController 
{
    public Contact newContact { get; set; }
    private ApexPages.StandardController stdController;

    public ContactCreationThroughAccountController(ApexPages.StandardController stdController) 
    {
        this.stdController = stdController;
        newContact = new Contact();
        newContact.AccountId = stdController.getId();
    }

    public PageReference saveContact()
    {
        try 
        {
            if(newContact!=null)
            {
                insert newContact;
            }
            return new PageReference('/' + newContact.AccountId);
        } 
        catch(Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
    }

    public PageReference cancel() 
    {
        return new PageReference('/' + newContact.AccountId);
    }
}
