public class SelectListController 
{
    public String field1                         { get; set; }
    public String field2                         { get; set; }
    public String field3                         { get; set; }
    public List<SelectOption> selectList         { get; set; }
    public List<SelectOption> secondarySelectList { get; set; }
    public List<SelectOption> thirdSelectList { get; set; }
    public Map<String, List<String>> picklistMap { get; set; }
    public Map<String, List<String>> picklistMap1 { get; set; }

    public SelectListController(){
        setupPickValMap();
        getPrimaryPickVals();
    }

    public void setupPickValMap(){
        picklistMap = new Map<String, List<String>>();
        picklistMap1=new Map<String, List<String>>();
        picklistMap.put('1', new List<String>{'D'});
        picklistMap.put('2', new List<String>{'E'});
        picklistMap1.put('A', new List<String>{'A1', 'C1'});
        picklistMap1.put('C', new List<String>{'A2', 'B2', 'C2', 'D2'});
    }

    public void getPrimaryPickVals(){
        selectList = new List<selectOption>();

        for(String s : picklistMap.keySet())
            selectList.add(new SelectOption(s, s));
       
        
        
    }

    public void getSecondaryPickVals()
    {
        if(field1 != null)
        {
            secondarySelectList = new List<selectOption>();
            
            for(String s : picklistMap1.keySet())
            secondarySelectList.add(new SelectOption(s, s));

            
        }
    }
        public void getThirdPickVals()
        {
        if(field2 != null)
        {
            thirdSelectList = new List<selectOption>();

            for(String s : picklistMap1.get(field2))
                thirdSelectList.add(new SelectOption(s, s));
        }
    }
}