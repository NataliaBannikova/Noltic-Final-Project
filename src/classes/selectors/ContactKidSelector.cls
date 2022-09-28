public with sharing class ContactKidSelector {
    public static List<AggregateResult> getNumberOfRelatedKidsForEachGroup(Set<Id> groupIds) {
        return  [SELECT Group_Name__c, COUNT(Id) numberOfKids FROM Contact WHERE Group_Name__c IN : groupIds GROUP BY Group_Name__c];
    }
}