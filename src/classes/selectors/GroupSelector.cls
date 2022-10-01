public with sharing class GroupSelector {
    public static List<AggregateResult> getNumberOfRelatedKidsForEachGroup() {
        return  [SELECT Group_Name__c, COUNT(Id) numberOfKids FROM Contact GROUP BY Group_Name__c];
    }

    public static Map<Id, Group__c> getGroupsMap(Set<Id> groupIds) {
        return  new Map<Id, Group__c>([SELECT Id, Number_of_kids__c, Group_Limit__c FROM Group__c WHERE Id IN : groupIds]);
    }
}