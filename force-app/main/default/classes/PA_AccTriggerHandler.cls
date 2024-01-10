public with sharing class PA_AccTriggerHandler
{
    public static void newAcc(List<Account> newAcc)
    {
        list<contact> conList=new list<Contact>();
        for(Account a:newAcc)
      {
           Contact con=new Contact();
           con.LastName=a.Name;
           con.AccountId=a.id;
           con.PA_Office_Country__c=a.PA_Office_Country__c;

           conList.add(con);
      }
        if(conList.size()>0)
        insert conList;
    }

      public static void updateAcc(List<Account> upAcc)
      {
        list<contact> conListNew=new list<Contact>();
        for(Account a1:upAcc)
        {
           Contact con1=new Contact();
           Account aOld=(Account)trigger.oldMap.get(a1.id);
           if(a1.Name != aold.Name)
           {
              con1.LastName=a1.Name;
              con1.AccountId=a1.id;
              con1.PA_Office_Country__c=a1.PA_Office_Country__c;

              conListNew.add(con1);
           }
         else 
          {
            if (a1.name == aold.name)
           {
            a1.addError('With same acc name the Country cant be changed');
            
           }
          }
        } 

             if(conListNew.size()>0)
             insert conListNew;
   
       }
       
}