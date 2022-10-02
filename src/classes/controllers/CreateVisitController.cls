public with sharing class CreateVisitController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getKids() {
        List<Contact> kidsLst = [SELECT Id, Name FROM Contact WHERE RecordType.Name = 'Kid' WITH SECURITY_ENFORCED];
        return kidsLst;
    }
}