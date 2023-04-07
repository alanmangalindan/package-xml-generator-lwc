// Alan Mangalindan (alan.mangalindan@davanti.co.nz)
@isTest
public class PackageXmlGeneratorControllerTest {

    @IsTest
    static void getChangedMetadataTest(){
        
        List<Profile> adminProfile = [SELECT Id, Name from Profile WHERE Name = 'System Administrator'];
        User adminUser = new User(FirstName = 'Test', LastName = 'AdminUser', Alias='TestAdmn', Email='some_email@testemailuser.co.nz', 
                                 Username = 'test.adminuser@my.unique.user.co.nz.sandbox', ProfileId = adminProfile[0].Id,
                                 LanguageLocaleKey = 'en_US', EmailEncodingKey='UTF-8', LocaleSidKey = 'en_NZ', TimeZoneSidKey = 'Pacific/Auckland');

        Map<String, HttpRequest> requests1;        
        Map<String, HttpRequest> requests2;        
        Map<String, HttpRequest> requests3;        
        Map<String, HttpRequest> requests4;

        Map<String, List<String>> packageXmlResult1;

        String errorMessage;        
        
        Test.startTest();        
        System.runAs(adminUser){
        	Continuation conti1 = (Continuation) PackageXmlGeneratorController.startContinuation('','', '57.0');
        	Continuation conti2 = (Continuation) PackageXmlGeneratorController.startContinuation(adminUser.Username,'1', '57.0');
        	Continuation conti3 = (Continuation) PackageXmlGeneratorController.startContinuation(adminUser.Username,'-1', '57.0');
        	Continuation conti4 = (Continuation) PackageXmlGeneratorController.startContinuation(adminUser.Username, 'not_a_number', '57.0');

        	// Store continuation requests
        	requests1 = conti1.getRequests(); 
        	requests2 = conti2.getRequests();      
        	requests3 = conti3.getRequests(); 
        	requests4 = conti4.getRequests();

            // Store the mock response
        	HttpResponse response = new SourceMemberMock().respond(requests1.values()[0]);
            // Set the mock response
            Test.setContinuationResponse(new List<String>(requests1.keySet())[0], response);
            packageXmlResult1 = PackageXmlGeneratorController.querySourceMember(new List<String>(requests1.keySet()), 'Query SourceMember Object via REST Tooling API');
        	System.debug(LoggingLevel.INFO, 'packageXmlResult1: ' + packageXmlResult1);

            Test.setContinuationResponse(new List<String>(requests1.keySet())[0], new SourceMemberMock().responseFailure(requests1.values()[0]));
            try {
                PackageXmlGeneratorController.querySourceMember(new List<String>(requests1.keySet()), 'Query SourceMember Object via REST Tooling API');
            }
            catch (Exception excep) {
                System.debug(LoggingLevel.INFO, 'excep: ' + excep);
                System.debug(LoggingLevel.INFO, 'excep.getMessage(): ' + excep.getMessage());
                errorMessage = excep.getMessage();
            }
        }
        Test.stopTest();
        
        System.debug(LoggingLevel.INFO, 'requests1: ' + requests1);
        System.debug(LoggingLevel.INFO, 'requests1.keySet(): ' + requests1.keySet());
        System.assert(requests1.size() == 1);
        System.debug(LoggingLevel.INFO, 'requests2: ' + requests2);
        System.debug(LoggingLevel.INFO, 'requests2.keySet(): ' + requests2.keySet());
        System.assert(requests2.size() == 1);
        System.debug(LoggingLevel.INFO, 'requests3: ' + requests3);
        System.debug(LoggingLevel.INFO, 'requests3.keySet(): ' + requests3.keySet());
        System.assert(requests3.size() == 1);
        System.debug(LoggingLevel.INFO, 'requests4: ' + requests4);
        System.debug(LoggingLevel.INFO, 'requests4.keySet(): ' + requests4.keySet());
        System.assert(requests4.size() == 1);

        System.assert(packageXmlResult1.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        System.assert(packageXmlResult1.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');

        System.assert(errorMessage.contains('Script-thrown exception'), 'Continuation Error scenario not achieved.');        
    }
}