public with sharing class CreateVisitController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getKids() {
        List<Contact> kidsLst = [SELECT Id, Name FROM Contact WHERE RecordType.Name = 'Kid' WITH SECURITY_ENFORCED];
        return kidsLst;
    }

    @AuraEnabled
    public static List<Contact> getRelatives(String selectedKidId) {
        List<KidsToResponsiblePersons__c> kidsToResponsiblePersonsLst = [
                SELECT Kid__c, Responsible_Person__r.Contact__r.Id
                FROM KidsToResponsiblePersons__c
                WHERE Kid__c = :selectedKidId];

        Set<Id> relativesIds = new Set<Id>();
        for(KidsToResponsiblePersons__c item: kidsToResponsiblePersonsLst) {
            relativesIds.add(item.Responsible_Person__r.Contact__r.Id);
        }

        List<Contact> relatives = [
                SELECT Id, Name
                FROM Contact
                WHERE RecordType.Name = 'Relative' AND Id = :relativesIds
        ];
        return relatives;
    }
}