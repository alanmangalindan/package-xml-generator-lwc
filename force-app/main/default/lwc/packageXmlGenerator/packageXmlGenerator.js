// Alan Mangalindan (alan.mangalindan@merkle.com)]
// packageXmLGenerator LWC
import { LightningElement } from 'lwc';
// import getChangedMetadata from '@salesforce/apex/PackageXmlGeneratorController.getChangedMetadata';
import startContinuation from '@salesforce/apexContinuation/PackageXmlGeneratorController.startContinuation';

export default class PackageXmlGenerator extends LightningElement {

    username = '';
    numberOfDays = '1';
    packageXml = '';
    apiVersion = '59.0';
    showSpinner = false;

    async generatePackage(event) {
        this.showSpinner = true;
        console.log(event.target.label);
        this.packageXml = ''; // clear the text box

        let inputs = this.template.querySelectorAll("lightning-input");

        inputs.forEach( inp => {
            if (inp.name == "usernameInput") {
                this.username = inp.value;
            }
            if (inp.name == "numberOfDaysInput") {
                this.numberOfDays = inp.value;
            }
            if (inp.name == "apiVersion") {
                this.apiVersion = inp.value;
            }
        })

        // console.log('username: ' + this.username);
        // console.log('numberOfDays: ' + this.numberOfDays);
        // console.log('packageXml: ' + this.packageXml);

        try {
            const result = await startContinuation({ username: this.username, 
                                                    numberOfDays: this.numberOfDays, 
                                                    apiVersion: this.apiVersion });
            
            if (result) {
                console.log('result.length: ' + result.length);
                console.log('result: ' + JSON.stringify(result));
                this.formatPackageXml(result);
            }
            else {
                // No results
               console.log('No results returned.');
               this.packageXml = 'No results retrieved from SourceMember object.';
            }
        } catch(error) {
            this.packageXml = 'Please ensure this is a source-tracked sandbox. Error occurred in PackageXmlGeneratorController Class: ' + JSON.stringify(error);
            console.log('Please ensure this is a source-tracked sandbox. Error occurred in PackageXmlGeneratorController Class: ' + JSON.stringify(error));
        } finally {
            this.showSpinner = false;
        }

        // getChangedMetadata ({ username: this.username,
        // startContinuation ({ username: this.username, 
        //                     numberOfDays: this.numberOfDays, 
        //                     apiVersion: this.apiVersion })
        // .then((result) => {
        //     if (result) {

        //         console.log('result.length: ' + result.length);
        //         console.log('result: ' + JSON.stringify(result));
        //         this.formatPackageXml(result);

        //     }
        //     else {
        //         // No results
        //        console.log('No results returned.');
        //        this.packageXml = 'No results retrieved from SourceMember object.';
        //     }
        // })
        // .catch((error) => {
        //     this.packageXml = 'Please ensure this is a source-tracked sandbox. Error occurred in PackageXmlGeneratorController Class: ' + JSON.stringify(error);
        //     console.log('Please ensure this is a source-tracked sandbox. Error occurred in PackageXmlGeneratorController Class: ' + JSON.stringify(error));
        // });        
    }

    formatPackageXml(apexResult) {
        console.log('In formatPackageXml method...');

        let tempXml = '';
        tempXml += '<?xml version="1.0" encoding="UTF-8"?>\n' +
                                '<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n';
        
        for (let key in apexResult) {
            if (key != 'LightningComponentResource') { // some Member Types are not part of package.xml

                console.log('MemberType is: ' + key);
                tempXml += '\t<types>\n';

                for(let i = 0; i < apexResult[key].length; i++){
                    console.log('MemberName is: ' + apexResult[key][i]);
                    tempXml += '\t\t<members>' + apexResult[key][i] + '</members>\n';
                }

                tempXml += '\t\t<name>' + key + '</name>\n';
                tempXml += '\t</types>\n';
            }
        }
        tempXml += '\t<version>' + this.apiVersion + '</version>\n' +
                    '</Package>';

        this.packageXml = tempXml;

        console.log('this.packageXml: ' + this.packageXml);
        
    }

}