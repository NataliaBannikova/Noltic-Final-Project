@IsTest
public with sharing class TestDtFactory {
    public static final Id CONTACT_RECORD_TYPE_TEACHER_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Teacher').getRecordTypeId();
    public static final Id CONTACT_RECORD_TYPE_KID_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Kid').getRecordTypeId();
    public static final Id CONTACT_RECORD_TYPE_RELATIVE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Relative').getRecordTypeId();

    public static Group__c createGroup(Id teacherId) {
        return new Group__c(Teacher__c = teacherId);
    }

    public static Group__c createGroupWithTeacher() {
        Contact teacher = new Contact(LastName = 'Test', MobilePhone = '1234567891', RecordTypeId= CONTACT_RECORD_TYPE_TEACHER_ID);
        insert teacher;
        return new Group__c(Teacher__c = teacher.Id);
    }

    public static Group__c createGroupWithKidsLimit(Integer groupLimit, Integer numberOfKids) {
        Group__c newGroup = new Group__c(Group_Limit__c = groupLimit, Number_of_kids__c = numberOfKids);
        return newGroup;
    }

    public static Contact createContactRecordTypeTeacher() {
        Contact teacher = new Contact(LastName = 'Test', MobilePhone = '1234567891', RecordTypeId= CONTACT_RECORD_TYPE_TEACHER_ID);
        return teacher;
    }

    public static Contact createContactRecordTypeRelative() {
        Contact relative = new Contact(LastName='Test', MobilePhone= '1234567891', RecordTypeId= CONTACT_RECORD_TYPE_RELATIVE_ID);
        return relative;
    }

    public static Responsible_Person__c createResponsiblePerson(Id relativeId) {
        Responsible_Person__c responsiblePerson = new Responsible_Person__c(Contact__c = relativeId);
        return responsiblePerson;
    }

    public static List<Contact> createKidsForGroup(Integer numberOfKids, Id groupId) {
        List<Contact> kids = new List<Contact>();
        for (Integer i = 0; i < numberOfKids; i++) {
            Contact kid = new Contact(LastName = 'Test'+i, Group_Name__c = groupId, RecordTypeId= CONTACT_RECORD_TYPE_KID_ID);
            kids.add(kid);
        }
        return kids;
    }

    public static List<Group__c> createGroupLstWithLimit (Integer groupLimit, Integer numberOfKids) {
        List<Group__c> groupsLst = new List<Group__c>();
        for (Integer i = 0; i < 5; i++) {
            Group__c g = new Group__c(Group_Limit__c = groupLimit, Number_of_kids__c = numberOfKids);
            groupsLst.add(g);
        }
        return groupsLst;
    }

    public static KidsToResponsiblePersons__c createKidsToResponsiblePersons(Id kidId, Id responsiblePersonId) {
        KidsToResponsiblePersons__c kidsToResponsiblePersons = new KidsToResponsiblePersons__c(Kid__c = kidId, Responsible_Person__c = responsiblePersonId);
        return kidsToResponsiblePersons;
    }
}