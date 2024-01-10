public with sharing class FirstVFLinkedClass {



    private string sortOrder = 'FirstName';

    private final Contact conData;


    public FirstVFLinkedClass(ApexPages.StandardController stdController){
        this.conData= (Contact)stdController.getRecord();

    }

   
   
    public List<Contact> getContacts()
    {
        List<Contact> results = Database.query(
            'SELECT ID, LASTNAME,FIRSTNAME, EMAIL '+
            'FROM CONTACT '+
            'ORDER BY '+sortOrder+' ASC '+
            'LIMIT 10'
        );
        return results;


    }
    public void sortByLastName()
    {
        this.sortOrder='LastName';
    }
    public void sortByFirstName()
    {
        this.sortOrder='FirstName';
    }

}
