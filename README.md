DFSurveys
=========

Dreamforce Survey App from 2013 breakout session


Instructions
============

Pull from github.
Refresh the Force.com IDE or deploy the changes via the migration tool/ForceCLI.

Grant access to the survey tabs and app to the sys admin profile.
Create a Force.com site for external access.

Add SurveyApp to site Visualforce pages.

Go to the public access settings for the site:
  Give read/edit access to Survey Response and Survey Question Response.
  Give access to all fields on Survey Question Response and the following fields on Survey Response:

  Complete
  Complete Date Time
  Contact
  Contact Name
  Description
  Start Date Time
  Survey Name

Create a Default Organization Level Value of the custom setting BaseConfiguration and add the address of the site 
to it - exclude the leading scheme (http:// or https://) but remember to include the path if there is one - e.g. for
the dev org I tested this on the site address field is:

   df13bg-developer-edition.eu2.force.com/webinar

Create a Survey and add a few survey questions. You'll need to fill in the option fields when using 
radio buttons or checkboxes.

Create a new survey response - this will open a Visualforce override page to allow selection of a Survey 
and a contact.  A workflow rule sends an email to the contact with a link and QR code.

When the contact takes the survey, the Survey Question Response child objects will
be updated with their response.
