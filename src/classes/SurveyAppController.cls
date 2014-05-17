/*******************************************************************
 * Custom controller for the Survey Application. 
 *
 * Provides remoting methods to retrieve and save a survey response 
 * and its associated questions
 * 
 * Author : Keir Bowden
 *******************************************************************/
public with sharing class SurveyAppController {
	
	/* 
	 * Remote method to retrieve a survey response and questions based on the survey response code
	 */
	@RemoteAction
	public static Survey_Response__c GetSurveyResponse(String code)
	{
		Survey_Response__c result=null;
		
		// query the response and question data for the supplied code
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
		
		// there should be exactly one match - if this is not the case throw an exception
		if (responses.size()!=1)
		{
			throw new SurveyException('No matching survey found');
		}
		else
		{
			// mark the start time for the survey as now
			responses[0].Start_Date_Time__c=System.now();
			update responses[0];
			
			// set the result to the single matching survey response
			result=responses[0];
		}
		
		return result;
	}
	
	/* 
	 * Remote method to save the question responses for a survey.
	 * Note that the survey response record is not passed to this method, as the end user
	 * cannot change any of the fields in that record so it would be overhead on the request.
	 */
	@RemoteAction
	public static void SaveSurveyResponse(List<Survey_Question_Response__c> qrs)
	{
		// write the question responses to the database
		update qrs;
		
		// get the id of the first element in the array - this will be used to retrieve the associated survey response
		Id qrId=qrs[0].Id;
		
		// pull back the survey response id for the question response
		Survey_Question_Response__c qr=[select id, Survey_Response__c from Survey_Question_Response__c where id=:qrId];
		
		// construct a new survey response record using the id of the existing response - this allows update of the record
		// without retrieving the details from the database.
		// set the survey response as complete and mark the end time as now 
		Survey_Response__c sr=new Survey_Response__c(id=qr.Survey_Response__c,
													Complete__c=true,
													Complete_Date_Time__c=System.now());
			
		update sr;
	}	
	
	// custom survey exception - allows an exception to be explicitly thrown from the controller 
	public class SurveyException extends Exception {}
	
}