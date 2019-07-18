public with sharing class StockXSalesCardListController {
	public StockXSalesCardListController() {}

	@AuraEnabled (cacheable=true)
	public static List<CardWrapper> getSalesData(){
		List<CardWrapper> cardWrappers = new List<CardWrapper>();

		for (StockX_Sale__c sale : [SELECT Name, Sneaker_Name__c, Buyer_Region__c, Number_of_Days_Listed__c, Sale_Price__c, Profit__c, Release_Date__c FROM StockX_Sale__c ORDER BY Profit__c DESC LIMIT 10]) {
			cardWrappers.add(new CardWrapper(sale));
		}

		return cardWrappers;
	}

	@AuraEnabled (cacheable=true)
	public static List<CardWrapper> getSalesDataWithPageSize(Integer numRecordsToLoad){
		List<CardWrapper> cardWrappers = new List<CardWrapper>();

		for (StockX_Sale__c sale : [SELECT Name, Sneaker_Name__c, Buyer_Region__c, Number_of_Days_Listed__c, Sale_Price__c, Profit__c, Release_Date__c FROM StockX_Sale__c ORDER BY Profit__c DESC LIMIT :numRecordsToLoad]) {
			cardWrappers.add(new CardWrapper(sale));
		}

		return cardWrappers;
	}

	@AuraEnabled (cacheable=true)
	public static Map<String, ObjectDescribe> getObjectDescribes() {
		return new Map<String, ObjectDescribe> {
			'stockXSale' => new ObjectDescribe(StockX_Sale__c.sObjectType.getDescribe())
		};
	}

	@AuraEnabled (cacheable=true)
	public static Map<String, FieldDescribe> getFieldDescribes() {
		return new Map<String, FieldDescribe> {
			'saleName' => new FieldDescribe(StockX_Sale__c.Name.getDescribe()),
			'salePrice' => new FieldDescribe(StockX_Sale__c.Sale_Price__c.getDescribe()),
			'sneakerName' => new FieldDescribe(StockX_Sale__c.Sneaker_Name__c.getDescribe()),
			'buyerRegion' => new FieldDescribe(StockX_Sale__c.Buyer_Region__c.getDescribe()),
			'numDaysListed' => new FieldDescribe(StockX_Sale__c.Number_of_Days_Listed__c.getDescribe()),
			'profit' => new FieldDescribe(StockX_Sale__c.Profit__c.getDescribe()),
			'releaseDate' => new FieldDescribe(StockX_Sale__c.Release_Date__c.getDescribe())
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

		@AuraEnabled public String saleId {get;set;}
		@AuraEnabled public String buyerRegion {get;set;}
		@AuraEnabled public String numDaysListed {get;set;}
		@AuraEnabled public String profit {get;set;}
		@AuraEnabled public String releaseDate {get;set;}
		@AuraEnabled public String sneakerName  {get;set;}
		@AuraEnabled public String salePrice  {get;set;}

		public CardWrapper() {}

		public CardWrapper(StockX_Sale__c sale) {
			saleId =  sale.Name;
			buyerRegion = sale.Buyer_Region__c;
			numDaysListed = sale.Number_of_Days_Listed__c.format();
			profit = sale.Profit__c.format();
			releaseDate = sale.Release_Date__c.format();
			sneakerName = sale.Sneaker_Name__c;
			salePrice = sale.Sale_Price__c.format();
		}

	}
}