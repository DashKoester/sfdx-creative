public with sharing class CardRecordListController {

	@AuraEnabled (cacheable=true)
	public static List<CardWrapper> getRecords() {
		List<CardWrapper> cardWrappers = new List<CardWrapper>();

		for (Tweet__c tweet : [SELECT Name, Body__c, Author_Username__c, Timestamp__c, Positive_Probability__c, Neutral_Probability__c, Negative_Probability__c FROM Tweet__c]) {
			cardWrappers.add(new CardWrapper(tweet));
		}

		System.debug(cardWrappers);
		return cardWrappers;
	}

	// @AuraEnabled (cacheable=true)
	// public static List<CardWrapper> getSalesDataWithPageSize(Integer numRecordsToLoad){
	// 	List<CardWrapper> cardWrappers = new List<CardWrapper>();

	// 	for (Tweet__c sale : [SELECT Name, Sneaker_Name__c, Buyer_Region__c, Number_of_Days_Listed__c, Sale_Price__c, Profit__c, Release_Date__c FROM Tweet__c]) {
	// 		cardWrappers.add(new CardWrapper(tweet));
	// 	}

	// 	return cardWrappers;
	// }

	@AuraEnabled (cacheable=true)
	public static Map<String, ObjectDescribe> getObjectDescribes() {
		return new Map<String, ObjectDescribe> {
			'tweet' => new ObjectDescribe(Tweet__c.sObjectType.getDescribe())
		};
	}

	@AuraEnabled (cacheable=true)
	public static Map<String, FieldDescribe> getFieldDescribes() {
		return new Map<String, FieldDescribe> {
			'name' => new FieldDescribe(Tweet__c.Name.getDescribe()),
			'body' => new FieldDescribe(Tweet__c.Body__c.getDescribe()),
			'authorUsername' => new FieldDescribe(Tweet__c.Author_Username__c.getDescribe()),
			'timestamp' => new FieldDescribe(Tweet__c.Timestamp__c.getDescribe()),
			'positiveProbability' => new FieldDescribe(Tweet__c.Positive_Probability__c.getDescribe()),
			'neutralProbability' => new FieldDescribe(Tweet__c.Neutral_Probability__c.getDescribe()),
			'negativeProbability' => new FieldDescribe(Tweet__c.Negative_Probability__c.getDescribe())
		};
	}

	public class ObjectDescribe {
		@AuraEnabled public String label {get;set;}
		@AuraEnabled public String apiName {get;set;}
		@AuraEnabled public Boolean isAccessible {get;set;}
		@AuraEnabled public Boolean isUpdateable {get;set;}

		public ObjectDescribe(Schema.DescribeSObjectResult objDescribe) {
			label =  objDescribe.getLabel();
			apiName = objDescribe.getName();
			isAccessible = objDescribe.isAccessible();
			isUpdateable = objDescribe.isUpdateable();
		}
	}

	public class FieldDescribe {
		@AuraEnabled public String label {get;set;}
		@AuraEnabled public String apiName {get;set;}
		@AuraEnabled public Boolean isAccessible {get;set;}
		@AuraEnabled public Boolean isUpdateable {get;set;}

		public FieldDescribe(Schema.DescribeFieldResult fieldDescribe) {
			label =  fieldDescribe.getLabel();
			apiName = fieldDescribe.getName();
			isAccessible = fieldDescribe.isAccessible();
			isUpdateable = fieldDescribe.isUpdateable();
		}
	}

	public class CardWrapper {

		@AuraEnabled public String tweetNumber {get;set;}
		@AuraEnabled public String body {get;set;}
		@AuraEnabled public String authorUsername {get;set;}
		@AuraEnabled public String timestamp {get;set;}
		@AuraEnabled public String positiveProbability {get;set;}
		@AuraEnabled public String neutralProbability  {get;set;}
		@AuraEnabled public String negativeProbability  {get;set;}

		public CardWrapper() {}

		public CardWrapper(Tweet__c tweet) {
			tweetNumber =  tweet.Name;
			body = tweet.Body__c;
			authorUsername = tweet.Author_Username__c;
			if (tweet.Timestamp__c != null) {
				timestamp = tweet.Timestamp__c.format();
			}
			if (tweet.Positive_Probability__c != null) {
				positiveProbability = tweet.Positive_Probability__c.format();
			}
			if (tweet.Neutral_Probability__c != null) {
				neutralProbability = tweet.Neutral_Probability__c.format();
			}
			if (tweet.Negative_Probability__c != null) {
				negativeProbability = tweet.Negative_Probability__c.format();
			}
		}
	}
}
