public with sharing class SentimentAnalysisBatch implements Database.Batchable<sObject> {
    public SentimentAnalysisBatch() {

    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Tweet__c';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        // Do Something
    }

    public void finish(Database.BatchableContext BC) {
        // FINISH
    }

}
