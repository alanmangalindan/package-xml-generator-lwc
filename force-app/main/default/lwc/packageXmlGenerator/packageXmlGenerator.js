// Alan Mangalindan (alan.mangalindan@merkle.com)]
// packageXmLGenerator LWC
import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import startContinuation from "@salesforce/apexContinuation/PackageXmlGeneratorController.startContinuation";
import Id from "@salesforce/user/Id";

export default class PackageXmlGenerator extends LightningElement {
    numberOfDays = "1";
    packageXml = "";
    apiVersion = "63.0";
    showSpinner = false;
    userId = Id; // set userId to the current user
    displayInfo = {
        primaryField: "Name",
        additionalFields: ["Username"]
    };
    matchingInfo = {
        primaryField: { fieldPath: "Name",  mode: "startsWith" },
        additionalFields: [{ fieldPath: "Username", mode: "startsWith" }]
    };
    filter = {
        criteria: [
            {
                fieldPath: "IsActive",
                value: true,
                operator: "eq"
            }
        ]
    };

    handleChange(event) {
        this.userId = event.detail.recordId;
    }

    async generatePackage(event) {
        this.showSpinner = true;
        console.log(event.target.label);
        this.packageXml = ""; // clear the text box

        let inputs = this.template.querySelectorAll("lightning-input");

        inputs.forEach((inp) => {
            if (inp.name == "numberOfDaysInput") {
                this.numberOfDays = inp.value;
            }
            if (inp.name == "apiVersion") {
                this.apiVersion = inp.value;
            }
        });

        try {
            const result = await startContinuation({
                userId: this.userId,
                numberOfDays: this.numberOfDays,
                apiVersion: this.apiVersion
            });

            if (result) {
                this.formatPackageXml(result);
            } else {
                // No results
                this.packageXml = "No results retrieved from SourceMember object.";
            }
        } catch (error) {
            if (this.userId === null) {
                this.packageXml = "Please select a User.";
            } else {
                this.packageXml =
                    "Please ensure this is a source-tracked sandbox. Error occurred in PackageXmlGeneratorController Class: " +
                    JSON.stringify(error);
                console.log(
                    "Please ensure this is a source-tracked sandbox. Error occurred in PackageXmlGeneratorController Class: " +
                        JSON.stringify(error)
                );
            }
        } finally {
            this.showSpinner = false;
        }
    }

    formatPackageXml(apexResult) {
        let tempXml = "";
        tempXml +=
            '<?xml version="1.0" encoding="UTF-8"?>\n' + '<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n';

        for (let key in apexResult) {
            if (key != "LightningComponentResource") {
                // some Member Types are not part of package.xml
                tempXml += "\t<types>\n";

                for (let i = 0; i < apexResult[key].length; i++) {
                    tempXml += "\t\t<members>" + apexResult[key][i] + "</members>\n";
                }

                tempXml += "\t\t<name>" + key + "</name>\n";
                tempXml += "\t</types>\n";
            }
        }
        tempXml += "\t<version>" + this.apiVersion + "</version>\n" + "</Package>";

        this.packageXml = tempXml;
    }

    copyToClipboard() {
        try {
            if (navigator.clipboard && window.isSecureContext) {
                const toastEvent = new ShowToastEvent({
                    title: "Successfully copied package.xml to clipboard!",
                    message: "",
                    variant: "success"
                });
                this.dispatchEvent(toastEvent);
                return navigator.clipboard.writeText(this.packageXml);
            }
        } catch (error) {
            const toastEvent = new ShowToastEvent({
                title: "Copy to clipboard failed. Please see browser console for error.",
                message: "",
                variant: "error"
            });
            this.dispatchEvent(toastEvent);
            console.log("Error copying to clipboard: ", error);
            return navigator.clipboard.writeText("");
        }
        console.log("Error copying to clipboard. Please enable Lightning Web Security in Setup > Session Settings.");
        const toastEvent = new ShowToastEvent({
            title: "Copy to clipboard failed.",
            message: "Please enable Lightning Web Security in Setup > Session Settings.",
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
        return navigator.clipboard.writeText("");
    }
}
