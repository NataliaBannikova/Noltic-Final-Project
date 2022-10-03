public with sharing class CreateVisitController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getKids() {
        List<Contact> kidsLst = [SELECT Id, Name FROM Contact WHERE RecordType.Name = 'Kid' WITH SECURITY_ENFORCED];
        return kidsLst;
    }

    @AuraEnabled
    public static List<Responsible_Person__c> getResponsiblePersons(String selectedKidId) {
        List<KidsToResponsiblePersons__c> kidsToResponsiblePersonsLst = [
                SELECT Kid__c, Responsible_Person__c
                FROM KidsToResponsiblePersons__c
                WHERE Kid__c = :selectedKidId];
        Set<Id> respPersonsIds = new Set<Id>();
        for(KidsToResponsiblePersons__c item: kidsToResponsiblePersonsLst) {
            respPersonsIds.add(item.Responsible_Person__c);
        }
        List<Responsible_Person__c> responsiblePersons = [
                SELECT Id, Name
                FROM Responsible_Person__c
                WHERE Id = :respPersonsIds
        ];
        return responsiblePersons;
    }
}