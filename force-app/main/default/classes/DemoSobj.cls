public class DemoSobj {

    public DemoSobj()
    {
        SObject obj; 
        obj = new Account(Name = 'Pankaj');
        Account acc= (Account) obj; 
        System.debug('SObject Value:'+ obj);
        //acc.Name('Pankaj');
        
    }
}