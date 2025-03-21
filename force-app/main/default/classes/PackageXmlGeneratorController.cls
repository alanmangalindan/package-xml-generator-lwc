// Alan Mangalindan (alan.mangalindan@davanti.co.nz)
// controller for packageXmlGenerator LWC to be used only in source-tracked sandboxes
public without sharing class PackageXmlGeneratorController {
    
    @AuraEnabled(continuation=true)
    public static Object startContinuation(String userId, String numberOfDays, String apiVersion) {

        Integer numDays = 1;

        String username = [SELECT Username from User WHERE Id = :userId][0].Username;
        if (String.isNotBlank(numberOfDays)) {
            try {
                Integer num = Integer.valueof(numberOfDays.trim());
                if (num > 0) {
                    numDays = num;
                }
                else {
                    System.debug(LoggingLevel.INFO, 'Number of Days is a negative number. Setting it to 1 day as default.');
                    numDays = 1;
                }
            }
            catch (Exception e) {
                System.debug(LoggingLevel.INFO, 'Error parsing number of days field: ' + e.getMessage() + '. Setting value as 1.');
                numDays = 1;
            }
        }
        else {
            numDays = 1; // keep numDays as 1
        }
    
        Continuation con = new Continuation(120);
        con.continuationMethod='querySourceMember';
        con.state='Query SourceMember Object via REST Tooling API';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
            String auth = 'Bearer '+ PackageXmlUserSessionHandler.fetchUserSessionId();
        req.setHeader('Authorization', auth);
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v' + apiVersion + '/tooling/query/?q=' + 
                                'SELECT+Id,+LastModifiedBy.Username,+LastModifiedDate,+MemberIdOrName,+MemberName,+MemberType+' + 
                                'from+SourceMember+WHERE+LastModifiedDate=LAST_N_DAYS:' + numDays + '+AND+LastModifiedBy.Username=\'' + username +
                                '\'+Order+By+LastModifiedDate+DESC');
        req.setMethod('GET'); 

        con.addHttpRequest(req);

        return con;
    }

    @AuraEnabled 
    public static Map<String, List<String>> querySourceMember(List<String> labels, Object state) {

        System.debug(LoggingLevel.INFO, 'labels: ' + labels);
        System.debug(LoggingLevel.INFO, 'state: ' + state);

        HttpResponse response = Continuation.getResponse(labels[0]);

        if (response.getStatusCode() == 200) {
            if (Test.isRunningTest()) { // to debug any test class failures
                System.debug(LoggingLevel.INFO, 'response.getBody(): ' + response.getBody());
            }
    
            Map<String, Object> calloutResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    
            System.debug(LoggingLevel.INFO, 'calloutResult.get(\'records\'): ' + calloutResult.get('records'));
    
            String changedMetadata = JSON.serialize(calloutResult.get('records'));
    
            List<SourceMemberWrapper> sourceMembers = (List<SourceMemberWrapper>) JSON.deserialize(changedMetadata, List<SourceMemberWrapper>.class);
    
            System.debug(LoggingLevel.INFO, 'sourceMembers.size(): ' + sourceMembers.size());
    
            Map<String, List<String>> packageXmlMap = new Map<String, List<String>>();
            Map<String, List<String>> packageXmlMapSorted = new Map<String, List<String>>();
    
            for(SourceMemberWrapper smw: sourceMembers) {
                List<String> tempMemberNames = packageXmlMap.get(smw.memberType);
                if (tempMemberNames != null && tempMemberNames.size() > 0) {
                    tempMemberNames.add(smw.memberName);
                    packageXmlMap.put(smw.memberType, tempMemberNames);
                }
                else {
                    List<String> tempList = new List<String>();
                    tempList.add(smw.memberName);
                    packageXmlMap.put(smw.memberType, tempList);
                }
            }
    
            Set<String> keysToSort = packageXmlMap.keySet();
            List<String> sortedKeys = new List<String>(keysToSort);
            sortedKeys.sort();
    
            for (String key : sortedKeys) {
                packageXmlMapSorted.put(key, packageXmlMap.get(key));
            }
    
            return packageXmlMapSorted;
        } 
        else {
            System.debug(LoggingLevel.INFO, 'response.getStatusCode(): ' + response.getStatusCode());
            System.debug(LoggingLevel.INFO, 'response.getStatus():' + response.getStatus());
            throw new AuraHandledException('Continuation Error --- ' + response.getStatusCode() + ' : ' + response.getStatus());
        }
        
    }

    public class SourceMemberWrapper {
        
        @AuraEnabled public String memberName;
        @AuraEnabled public String memberType;
    }
}