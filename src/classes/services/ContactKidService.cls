public with sharing class ContactKidService {
    public static final Id CONTACT_RECORD_TYPE_KID_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Kid').getRecordTypeId();

    public static void validateNumberOfKidsPerGroup(List<Contact> contacts) {
        List<Contact> contactRecTypeKid = getContactRecTypeKid(contacts);
        Set<Id> groupIds = getGroupsIds(contacts);
        Map<Id, Group__c> groupsMap = GroupSelector.getGroupsMap(groupIds);
        for (Contact contact : contactRecTypeKid) {
            Group__c currentGroup = groupsMap.get(contact.Group_Name__c);
            if(currentGroup.Number_of_kids__c >= currentGroup.Group_Limit__c) {
                contact.Group_Name__c.addError(Label.Group_Limit_is_reached);
            }
        }
    }

    public static void updateAmountOfKidsOnGroup(List<Contact> contacts) {
        List<AggregateResult> aggregateResults = GroupSelector.getNumberOfRelatedKidsForEachGroup();
        List<Group__c> groupsToUpdate = new List<Group__c>();
        for (AggregateResult ar : aggregateResults) {
                groupsToUpdate.add(new Group__c(Id = (Id) ar.get('Group_Name__c'), Number_of_kids__c = (Integer) ar.get('numberOfKids')));
        }
        if (groupsToUpdate.size()>0) {
            update groupsToUpdate;
        }
    }

    private static List<Contact> getContactRecTypeKid(List<Contact> contacts) {
        List<Contact> contactRecTypeKid = new List<Contact>();
        for (Contact c : contacts) {
            if(c.RecordTypeId == CONTACT_RECORD_TYPE_KID_ID) {
                contactRecTypeKid.add(c);
            }
        }
        return contactRecTypeKid;
    }

    private static Set<Id> getGroupsIds(List<Contact> contactRecTypeKid) {
        Set<Id> groupIds = new Set<Id>();
        for (Contact contact : contactRecTypeKid) {
            if(contact.Group_Name__c != null) {
                groupIds.add(contact.Group_Name__c);
            }
        }
        return groupIds;
    }
}