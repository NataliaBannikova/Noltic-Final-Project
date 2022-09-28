public with sharing class ContactKidService {

    public static void validateNumberOfKidsPerGroup(List<Contact> contacts) {
        Id contRecordTypeKidId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Kid').getRecordTypeId();
        System.debug(contRecordTypeKidId);
        Set<Id> groupIds = new Set<Id>();
        for (Contact c : contacts) {
            System.debug(c);
            System.debug(c.RecordTypeId);
            if(c.RecordTypeId == contRecordTypeKidId) {
                groupIds.add(c.Group_Name__c);
            }
        }
        System.debug(groupIds);

        if (groupIds.size() != null) {
            Map<Id, Group__c> groups = new Map<Id, Group__c>([SELECT Id, Number_of_kids__c, Group_Limit__c FROM Group__c WHERE Id IN : groupIds]);
            System.debug(groups);
            for (Contact c : contacts) {
                if(c.RecordTypeId == contRecordTypeKidId) {
                    Group__c currentGroup = groups.get(c.Group_Name__c);
                    System.debug(currentGroup);
                    if(currentGroup.Number_of_kids__c > currentGroup.Group_Limit__c) {
                        c.Group_Name__c.addError('Please, choose another Group! A Group Limit is reached - ' + currentGroup.Group_Limit__c);
                    }
                }
            }
        }

    }

    public static void updateAmountOfKidsOnGroup(List<Contact> contacts) {
        Id contRecordTypeKidId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Kid').getRecordTypeId();
        System.debug(contRecordTypeKidId);
        Set<Id> groupIds = new Set<Id>();
        for (Contact c : contacts) {
            System.debug(c);
            System.debug(c.RecordTypeId);
            if(c.RecordTypeId == contRecordTypeKidId) {
                groupIds.add(c.Group_Name__c);
            }
        }
        System.debug(groupIds);

        List<AggregateResult> aggregateResults = ContactKidSelector.getNumberOfRelatedKidsForEachGroup(groupIds);
        System.debug(aggregateResults);
        List<Group__c> groupsToUpdate = new List<Group__c>();

        for (AggregateResult ar : aggregateResults) {
            groupsToUpdate.add(new Group__c(Id = (Id) ar.get('Group_Name__c'), Number_of_kids__c = (Integer) ar.get('numberOfKids')));
        }
        System.debug(groupsToUpdate);
        if (groupsToUpdate.size()>0) {
            update groupsToUpdate;
        }
    }
}