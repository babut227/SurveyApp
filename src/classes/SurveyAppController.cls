public with sharing class SurveyAppController {
	
	@RemoteAction
	public static Survey_Response__c GetSurveyResponse(String code)
	{
		Survey_Response__c result=null;
		List<Survey_Response__c> responses=[select id, Name, Description__c, Code__c, Complete__c, Complete_Date_Time__c, 
													Start_Date_Time__c, Survey_Name__c,
													(select id, Question_Text__c, Question_Type__c, Index__c, Response__c,
														Option_1__c, Option_2__c, Option_3__c, Option_4__c, Option_5__c, 
														Option_6__c, Option_7__c, Option_8__c, Option_9__c, Option_10__c,
														Help_Text__c, Survey_Response__c
													from Survey_Question_Responses__r
													order by Index__c ASC)
											from Survey_Response__c
					 						where Code__c=:code];


		System.debug('### Responses.size = ' + responses.size());
		if (responses.size()!=1)
		{
			throw new SurveyException('No matching survey found');
		}
		else
		{
			responses[0].Start_Date_Time__c=System.now();
			update responses[0];
			
			result=responses[0];
		}
		
		return result;
	}
	
	@RemoteAction
	public static void SaveSurveyResponse(List<Survey_Question_Response__c> qrs)
	{
		String result='SUCCESS';
		update qrs;
		Id qrId=qrs[0].Id;
		Survey_Question_Response__c qr=[select id, Survey_Response__c from Survey_Question_Response__c where id=:qrId];
		Survey_Response__c sr=new Survey_Response__c(id=qr.Survey_Response__c,
													Complete__c=true,
													Complete_Date_Time__c=System.now());
			
		update sr;
	}	
	
	public class SurveyException extends Exception {}
	
}