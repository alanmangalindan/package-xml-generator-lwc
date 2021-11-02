// Reference: https://salesforcescool.blogspot.com/2021/06/get-session-id-of-logged-in-user-in.html
public without sharing class PackageXmlUserSessionHandler {
    public static String fetchUserSessionId(){
        String sSessionId = '';        
        PageReference sessionIdPage = Page.PackageXmlUserSessionPage;

        String vfContent = '';

        if (!Test.isRunningTest()) {
            // Get the content of the VF page
            vfContent = sessionIdPage.getContent().toString();
        }
        else {
            vfContent = 'Start_SomeSessionIdValue_End';
        }
        // Find the position of Start and End
        Integer startPosition = vfContent.indexOf('StartSessionId') + 'StartSessionId'.length();
        Integer endPosition = vfContent.indexOf('EndSessionId');
        // Get the Session Id
        sSessionId = vfContent.substring(startPosition, endPosition);
        System.debug(LoggingLevel.INFO, 'sessionId: '+sSessionId);
        // Return Session Id
        return sSessionId;
    }
}