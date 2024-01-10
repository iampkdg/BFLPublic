public class PicklistController {
    
    public String continent { get; set; }
    public String country { get; set; }
    public String city { get; set; }  
    public List<SelectOption> selectList {get;set;}
    public List<SelectOption> secondarySelectList {get;set;}
    public List<SelectOption> thirdSelectList {get;set;}
    public Map<String, List<String>> picklistMap1 { get; set; }
    public Map<String, List<String>> picklistMap2 { get; set; }
    
     public PicklistController()
     {
        setupPickValMap();
        getPrimaryPickVals();
        getSecondaryPickVals();
        getThirdPickVals();
        
    }
    
    public void setupPickValMap()
    {
        picklistMap1 = new Map<String, List<String>>();
        picklistMap1.put('Asia', new List<String>{'India', 'Pakistan'});
        picklistMap1.put('Europe', new List<String>{'Germany', 'France'});
        //picklistMap.put('3', new List<String>{'A', 'C'});
        //picklistMap.put('4', new List<String>{'A', 'B', 'C', 'D', 'E'});
        picklistMap2.put('India', new List<String>{'Puri','Kolkata','Durgapur'});
        
    }
    public void getPrimaryPickVals(){
        selectList = new List<selectOption>();

        for(String s : picklistMap1.keySet())
            selectList.add(new SelectOption(s, s));
    }

    public void getSecondaryPickVals()
    {
        if(continent != null)
        {
            secondarySelectList = new List<selectOption>();

            for(String s : picklistMap1.get(continent))
                secondarySelectList.add(new SelectOption(s, s));
        }
        
    }
        public void getThirdPickVals()
    {
        if(country != null)
        {
            thirdSelectList = new List<selectOption>();

            for(String s : picklistMap2.get(country))
                thirdSelectList.add(new SelectOption(s, s));
        }
        
    }
    

}