global class BaseConfigurationUtils 
{
	private static Base_Configuration__c baseConfig;
	
	private static Base_Configuration__c GetBaseConfiguration()
	{
		System.debug('#### Getting base configuration');
		if (null==baseConfig)
		{
			baseConfig = Base_Configuration__c.getOrgDefaults();
		}
		
		System.debug('#### Done - bc = ' + baseConfig);
		
		return baseConfig;
	}
	
	global static String GetSiteAddress()
	{
		String result;
		
		Base_Configuration__c bc=GetBaseConfiguration();
		
		if (null!=bc)
		{
			result=bc.Site_Address__c;		
		}
		
		if (null==result)
		{
			result=DEFAULT_SITE_ADDRESS;
		}
		
		return result;
	}
}