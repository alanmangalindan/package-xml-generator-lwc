/**
 * @author Alan Mangalindan (alan.mangalindan@merkle.com)
 * @description Mock class for retrieved REST API Versions
 */
@isTest
public with sharing class ApiVersionMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody(
            '[\n' +
                '{\n' +
                '  "label" : "Spring \'25",\n' +
                '  "url" : "/services/data/v63.0",\n' +
                '  "version" : "63.0"\n' +
                '},\n' +
                '{\n' +
                '  "label" : "Summer \'25",\n' +
                '  "url" : "/services/data/v64.0",\n' +
                '  "version" : "64.0"\n' +
                '}\n' +
                ']\n'
        );
        response.setStatusCode(200);
        return response;
    }

    public HttpResponse responseFailure(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('ApiVersionMock Simulated Callout failure');
        response.setStatusCode(2000);

        return response;
    }
}
