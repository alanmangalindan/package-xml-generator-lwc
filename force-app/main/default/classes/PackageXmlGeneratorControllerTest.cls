// Alan Mangalindan (alan.mangalindan@davanti.co.nz)
@isTest
public class PackageXmlGeneratorControllerTest {
    
    @TestSetup
    static void makeData(){
        
    }

    @IsTest
    static void getChangedMetadataTest(){

        User adminUser = [SELECT Id, Username FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new SourceMemberMock());

        Map<String, List<String>> packageXmlResult1;
        Map<String, List<String>> packageXmlResult2;
        Map<String, List<String>> packageXmlResult3;
        Map<String, List<String>> packageXmlResult4;
        
        Test.startTest();
        
        System.runAs(adminUser){
        Continuation conti1 = (Continuation) PackageXmlGeneratorController.startContinuation('','', '57.0');
        Continuation conti2 = (Continuation) PackageXmlGeneratorController.startContinuation(adminUser.Username,'1', '57.0');
        Continuation conti3 = (Continuation) PackageXmlGeneratorController.startContinuation(adminUser.Username,'-1', '57.0');
        Continuation conti4 = (Continuation) PackageXmlGeneratorController.startContinuation(adminUser.Username, 'not_a_number', '57.0');

        // Verify that the continuation has the proper requests
        Map<String, System.HttpRequest> requests1 = conti1.getRequests();
        System.debug('requests1: ' + requests1);
        System.debug('requests1.keySet(): ' + requests1.keySet());
        System.Assert(requests1.size() == 1);
        Map<String, HttpRequest> requests2 = conti2.getRequests();
        System.Assert(requests2.size() == 1);
        Map<String, HttpRequest> requests3 = conti3.getRequests();
        System.Assert(requests3.size() == 1);
        Map<String, HttpRequest> requests4 = conti4.getRequests();
        System.Assert(requests4.size() == 1);

        HttpResponse response = new SourceMemberMock().respond(requests1.values()[0]);
        System.debug('response: ' + response);
        Test.setContinuationResponse(new List<String>(requests1.keySet())[0], response);
        packageXmlResult1 = PackageXmlGeneratorController.querySourceMember(new List<String>(requests1.keySet()), response);
        System.debug('packageXmlResult1: ' + packageXmlResult1);

        
       
        //     packageXmlResult1 = PackageXmlGeneratorController.getChangedMetadata('','', '54.0');
        //     packageXmlResult2 = PackageXmlGeneratorController.getChangedMetadata(adminUser.Username,'1', '54.0');
        //     packageXmlResult3 = PackageXmlGeneratorController.getChangedMetadata(adminUser.Username,'-1', '54.0');
        //     packageXmlResult4 = PackageXmlGeneratorController.getChangedMetadata(adminUser.Username, 'not_a_number', '54.0');
        }
        Test.stopTest();

        System.assert(packageXmlResult1.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        System.assert(packageXmlResult1.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        // System.assert(packageXmlResult2.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult2.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        // System.assert(packageXmlResult3.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult3.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        // System.assert(packageXmlResult4.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult4.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');

        // System.assert(packageXmlResult1.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult1.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        // System.assert(packageXmlResult2.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult2.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        // System.assert(packageXmlResult3.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult3.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        // System.assert(packageXmlResult4.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        // System.assert(packageXmlResult4.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        
    }
}