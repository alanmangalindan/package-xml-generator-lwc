# package-xml-generator-lwc

Generate formatted package.xml content on screen based on components changed by a user
Note: This can only be used in a Source-tracked Developer sandbox or Developer Pro sandbox.
To turn on source-tracking in your sandbox refer to below link:
https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_setup_enable_source_tracking_sandboxes.htm

# How to deploy to your Developer or Developer Pro Sandbox?
Use the sfdx cli:
sfdx force:source:deploy -x "manifest/package.xml" -u <Sandbox_org_alias>

Note: This modifies the System Admin profile by default so that profile would get access to the deployed components. You can modify any other profile after deployment to the org.

# How to use:
1. After logging in to the sandbox, click App Launcher
2. Find and select tab: "Package.xml Generator LWC"
3. Click on "Generate package.xml"
4. Expand the text area if needed and copy the resulting package.xml text which you can paste into your own package.xml file

Note: By default the username defaults to the logged in user and the Days in Scope is 1. You can update these fields prior to clicking the button.

![image](https://user-images.githubusercontent.com/46139665/139955442-6b7891b0-40f7-454f-8d3b-07e848224ed6.png)
