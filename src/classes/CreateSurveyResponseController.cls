public with sharing class CreateSurveyResponseController 
{
	public Id surveyId {get; set;}
	public String surveyDescription {get; set;}
	public List<SelectOption> surveys {get; set;}
	private Map<Id, Survey__c> surveysById {get; set;}
	public Survey_Response__c rsp {get; set;}
	
	// extension constructor - not used, but allows this page to override
	// the new survey response behaviour
	public CreateSurveyResponseController(ApexPages.StandardController stdCtrl)
	{
		this();
	}
	
	public CreateSurveyResponseController()
	{
		surveys=new List<SelectOption>();
		surveysById=new Map<Id, Survey__c>();
		for (Survey__c srv : [select id, Name, Description__c from Survey__c])
		{
			if (null==surveyId)
			{
				surveyId=srv.id;
				surveyDescription=srv.Description__c;
			}
			surveys.add(new SelectOption(srv.Id, srv.Name));
			surveysById.put(srv.id, srv);
		}
		
		rsp=new Survey_Response__c();
	}
	
	public void surveyChanged()
	{
		surveyDescription=surveysById.get(surveyId).Description__c;
	}
	
	public PageReference Save()
	{
		Survey_Response__c result=SurveyUtils.CreateSurveyResponse(surveyId, rsp.Contact__c);
		
		return new PageReference('/' + result.id);
	}
}