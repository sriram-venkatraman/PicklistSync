@RestResource(urlMapping='/PickLists/*')
global with sharing class PickListResource {

    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String, String> inParams = req.params;

        List<String> inPickLists = new List<String>();
        if (inParams.size() > 0) {
        	inPickLists = inParams.get('l').split(',');
        }
         
		GetPicklistValues gp;
        if (inPickLists.size() > 0) {
            gp = new GetPicklistValues(inPickLists);
        }
        else {
	        gp = new GetPicklistValues();
        }

        res.addHeader('Content-Type', 'application/json');
        PickLists p = new PickLists();
        p.pickLists = gp.getList();
        res.responseBody = Blob.valueOf(JSON.serialize(p));
    }
    
    global void doGet(String inList) {
        List<String> inPickLists = inList.split(',');
		GetPicklistValues gp;
        system.debug(inPickLists);
        if (inPickLists.size() > 0) {
            gp = new GetPicklistValues(inPickLists);
        }
        else {
	        gp = new GetPicklistValues();
        }
        
        PickLists p = new PickLists();
        p.pickLists = gp.getList();
        System.Debug(JSON.serialize(p));
    }

    class PickLists {
        List<Object> pickLists;
    }
}