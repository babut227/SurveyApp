public without sharing class SurveyUtils 
{
	public static Survey_Response__c CreateSurveyResponse(Id chosenSurveyId, Id contactId)
	{
		List<Contact> contacts=[select id, FirstName, LastName, Email from Contact where id=:contactId];
		Contact cont;
		if (contacts.size()>0)
		{
			cont=contacts[0];
		}
		else
		{
			return null;
		}
		
		List<Survey__c> surveys=[select id, Name, Description__c from Survey__c where id = :chosenSurveyId];
		Survey__c survey;
		if (surveys.size()>0)
		{
			survey=surveys[0];
		}
		else
		{
			return null;
		}
		
		Survey_Response__c sr=new Survey_Response__c();
		sr.Contact__c=cont.id;
		sr.Name=survey.Name + '- ' + cont.FirstName + ' ' + cont.LastName;
		sr.Survey_Name__c=survey.Name;
		sr.Description__c=survey.Description__c;
		
		DateTime now = System.now();         
        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+ now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';         
        String canonical = sr.id + sr.Name + formattednow;                        
        Blob bsig = Crypto.generateDigest('MD5', Blob.valueOf(canonical));         
        String token =  EncodingUtil.base64Encode(bsig);                 
        if(token.length() > 255) 
        { 
        	token =  token.substring(0,254); 
        }
                
        sr.Code__c = Encodingutil.urlEncode(token, 'UTF-8').replaceAll('%','_');		
        insert sr;
		
		List<Survey_Question_Response__c> sqrs=new List<Survey_Question_Response__c>();
		for (Survey_Question__c sq : [select id, Name, Question_Text__c, Question_Type__c, Index__c,
									Option_1__c, Option_2__c, Option_3__c, Option_4__c, Option_5__c,
									Option_6__c, Option_7__c, Option_8__c, Option_9__c, Option_10__c,
									Help_Text__c
									from Survey_Question__c
									where Survey__c=:survey.id
									order by Index__c])
		{
			Survey_Question_Response__c sqr=new Survey_Question_Response__c();
			sqr.Question_Text__c=sq.Question_Text__c;
			sqr.Question_Type__c=sq.Question_Type__c;
			sqr.Help_Text__c=sq.Help_Text__c;
			sqr.Index__c=sq.Index__c;
			sqr.Option_1__c=sq.Option_1__c;
			sqr.Option_2__c=sq.Option_2__c;
			sqr.Option_3__c=sq.Option_3__c;
			sqr.Option_4__c=sq.Option_4__c;
			sqr.Option_5__c=sq.Option_5__c;
			sqr.Option_6__c=sq.Option_6__c;
			sqr.Option_7__c=sq.Option_7__c;
			sqr.Option_8__c=sq.Option_8__c;
			sqr.Option_9__c=sq.Option_9__c;
			sqr.Option_10__c=sq.Option_10__c;
			sqr.Survey_Response__c=sr.id;
			sqrs.add(sqr);
		}
		
		insert sqrs;
		
		return sr;
	}

	public static Id GetContactId(String emailAddress)
	{
		
		Id contid=null;
		
		List<Contact> contacts=[select id, Email from Contact where Email=:emailAddress];
		if (contacts.size()>0)
		{
			contId=contacts[0].id;
		}
		else
		{
			Contact cont=new Contact(Email=emailAddress);
			List<Account> accounts=[select id from Account where name='BrightGen'];
			Account acc;
			if (accounts.size()==0)
			{
				acc=new Account(name='BrightGen');
				insert acc;
			}
			else
			{
				acc=accounts[0];
			}
			
			cont.AccountId=acc.id;
			if (String.IsBlank(cont.FirstName))
			{
				cont.FirstName=cont.Email;
			}
			if (String.IsBlank(cont.LastName))
			{
				cont.LastName=cont.Email;
			}
			insert cont;
			contId=cont.id;
		}
		
		return contId;
	}
}