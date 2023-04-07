// Alan Mangalindan (alan.mangalindan@davanti.co.nz)
@isTest
public class SourceMemberMock implements HttpCalloutMock{
    
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('{\n' + 
            '"size" : 2,\n' +
            '"totalSize" : 2,\n' +
          '"done" : true, \n' +
          '"queryLocator" : null, \n' +
          '"entityTypeName" : "SourceMember", \n' +
          '"records" : [ { \n' +
          '  "attributes" : { \n' +
          '    "type" : "SourceMember", \n' +
          '    "url" : "/services/data/v52.0/tooling/sobjects/SourceMember/0MZ4Y00000097iwWAA" \n' +
          '  }, \n' +
          '  "Id" : "0MZ4Y00000097iwWAA", \n' +
          '  "LastModifiedBy" : { \n' +
          '    "attributes" : { \n' +
          '      "type" : "User", \n' +
          '      "url" : "/services/data/v52.0/tooling/sobjects/User/0052e000000JEPfAAO" \n' +
          '    }, \n' +
          '    "Username" : "alan.mangalindan@dev-ed.co.nz.mysandbox" \n' +
          '  }, \n' +
          '  "MemberName" : "PackageXmlGeneratorController", \n' +
          '  "MemberType" : "ApexClass" \n' +
          '}, { \n' +
          '  "attributes" : { \n' +
          '    "type" : "SourceMember", \n' +
          '    "url" : "/services/data/v52.0/tooling/sobjects/SourceMember/0MZ4Y0000005vFQWAY" \n' +
          '  }, \n' +
          '  "Id" : "0MZ4Y0000005vFQWAY", \n' +
          '  "LastModifiedBy" : { \n' +
          '    "attributes" : { \n' +
          '      "type" : "User", \n' +
          '      "url" : "/services/data/v52.0/tooling/sobjects/User/0052e000000JEPfAAO" \n' +
          '    }, \n' +
          '    "Username" : "alan.mangalindan@dev-ed.co.nz.mysandbox" \n' +
          '  }, \n' +
          '  "MemberName" : "PackageXmlGeneratorControllerTest", \n' +
          '  "MemberType" : "ApexClass" \n' +
          '}]\n ' +
        '}' 
        );
        response.setStatusCode(200);
        return response; 
    }

    public HttpResponse responseFailure(HttpRequest request) {

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('Simulated Callout failure');
        response.setStatusCode(2000);

        return response;
    }
}