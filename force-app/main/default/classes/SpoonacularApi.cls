public with sharing class SpoonacularApi 
{

    private static final string SPOONACULAR_API = 'https://api.spoonacular.com'; 
    
    public static void getResponse()
    {
        if (SPOONACULAR_API == 'https://api.spoonacular.com')
    {
        system.debug('OK');
    } 
        
    }
    
   
    private static final string API = '0f1bcc66bbbb4eddae03b34b6b28ea9e';


    public static void getSpoonacularApi ()
     {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(SPOONACULAR_API + '/recipes/analyze'+API);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
         if(response.getStatusCode()== 404)
         {
             system.debug('Error');
         }
             
        system.debug(response.getBody());
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) 
        {
        System.debug('response' +response.getBody());
    
        }

    }
} 
   /* public static void getReceipeByID (String recepieId)
    {
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint(SPOONACULAR_API + '/recipes/'+recepieId+'information'+API);
       //https://api.spoonacular.com/recipes/{id}/information --> for {id} we are passing a string as a parameter and then adding it. 
       request.setMethod('GET');
       HttpResponse response = http.send(request);
       system.debug(response.getBody());
       // If the request is successful, parse the JSON response.
       if(response.getStatusCode() == 200) 
       {
       System.debug('response' +response.getBody());
   
       }

    }

    public static void getReceipeByIngrediant (String ingrediants)
    {
       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint(SPOONACULAR_API + '/recipes/'+API+'&ingrediants'+ingrediants);
       // https://api.spoonacular.com/recipes/findByIngredients 
       // parameters passing
       // https://api.spoonacular.com/recipes/findByIngredients?ingredients=apples,+flour,+sugar&number=2  --> use '&' for more than one passing after the api. 
       request.setMethod('GET');
       HttpResponse response = http.send(request);
       system.debug(response.getBody());
       // If the request is successful, parse the JSON response.
       if(response.getStatusCode() == 200) 
       {
       System.debug('response' +response.getBody());
   
       }

   }
}*/