public class GetPicklistValues {
    List<String> pickListNames = new List<String>();    
    List<String> sObjects = new List<String>();
    Map<String, Schema.DescribeSobjectResult> sObjectDescribes = new Map<String, Schema.DescribeSobjectResult>();
	
    public GetPicklistValues() {
        for (Picklists_to_Sync__mdt p2s : [select Field_Name__c from Picklists_to_Sync__mdt where Active__c = true]) {
            pickListNames.add(p2s.Field_Name__c);
        }
    }
    
    public GetPicklistValues(List<String> inList) {
    	pickListNames = inList.clone();
    }

    public List<PickList> getList() {
        List<PickList> retList = new List<PickList>();
        
        String tmpStr;
        for (String pl : pickListNames) {
            tmpStr = pl.split('\\.')[0];
            if (!sObjects.contains(tmpStr)) {
                sObjects.add(tmpStr);
            }
        }
        
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(sObjects);
        for (Schema.DescribeSObjectResult sd : descResult) {
            sObjectDescribes.put(sd.getName(), sd);
            Map<String, Schema.SObjectField> fMap = sd.fields.getMap();
            for( String field : fMap.keySet() ) {
                if (pickListNames.contains(sd.getName() + '.' + fMap.get(field).getDescribe().getName())) {
                    system.debug('# ' + sd.getName() + '.' + fMap.get(field).getDescribe().getName());
                    Schema.DescribeFieldResult obj = fMap.get(field).getDescribe();
                    PickList pl = new PickList();
                    pl.fieldName = sd.getName() + '.' + obj.getName();
                    pl.pickListValues = new List<PickListValues>();
                    for (Schema.PicklistEntry ple : obj.getPicklistValues()) {
	                    PickListValues plv = new PickListValues();
						plv.label = ple.getLabel();
                        plv.value = ple.getValue();
                        plv.isActive = ple.isActive();
                        plv.isDefaultValue = ple.isDefaultValue();
                        pl.pickListValues.add(plv);
                    }
                    retList.add(pl);
                }
            }
        }
        
        return retList;
    }    
	
    class PickList {
        String fieldName;
		List<PickListValues> pickListValues;
    }
    
    class PickListValues {
        String label;
		String value;
        Boolean isActive;
        Boolean isDefaultValue;
    }
}