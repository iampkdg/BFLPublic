public with sharing class ContactTriggerHandler {
    
    public static void ContactTriggerHanlderMethod(List<Contact> contacts)
    {
       
        List<Contact> contactList= [Select id, Encrypted_Contact_Id__c From Contact where id =: contacts];
        List<Contact> contoadd= new List<Contact>();
        
        for(Contact con: contactList)
        {
            String conId= con.Id;
            //data to encrypt
            Blob data= Blob.valueOf(conId);
            //generate the key
			Blob key= crypto.generateAesKey(128);
            //generate the initialization vector
			Blob initVector = crypto.generateAesKey(128);
            //encrypt the data
			Blob encryptedData=crypto.encrypt('AES128',key,initVector,data);
			System.debug('Encrypted Data ---> '+EncodingUtil.base64Encode(encryptedData));
            //copy the encrypted data
            con.Encrypted_Contact_Id__c= EncodingUtil.base64Encode(encryptedData);
            contoadd.add(con);
         }
        update(contoadd);
        
    }
        
    }