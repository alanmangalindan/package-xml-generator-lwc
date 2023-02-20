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
            packageXmlResult1 = PackageXmlGeneratorController.getChangedMetadata('','', '54.0');
            packageXmlResult2 = PackageXmlGeneratorController.getChangedMetadata(adminUser.Username,'1', '54.0');
            packageXmlResult3 = PackageXmlGeneratorController.getChangedMetadata(adminUser.Username,'-1', '54.0');
            packageXmlResult4 = PackageXmlGeneratorController.getChangedMetadata(adminUser.Username,'not_a_number', '54.0');
        }
        Test.stopTest();

        System.assert(packageXmlResult1.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        System.assert(packageXmlResult1.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        System.assert(packageXmlResult2.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        System.assert(packageXmlResult2.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        System.assert(packageXmlResult3.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        System.assert(packageXmlResult3.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        System.assert(packageXmlResult4.keySet().contains('ApexClass'), 'MemberType returned is not ApexClass');
        System.assert(packageXmlResult4.values()[0].size() == 2, '2 MemberName values were not returned in the HTTP mock callout.');
        
    }
}