public with sharing class GroupTriggerHandler {
    public static void handler(List<Group__c> groups, Map<Id,Group__c> groupsOld, System.TriggerOperation triggerOperation) {
        switch on triggerOperation {
            when BEFORE_INSERT {
                GroupService.OneToOneValidateOnInsert(groups);
            }
            when BEFORE_UPDATE {
                GroupService.OneToOneValidateOnUpdate(groups,groupsOld);
                GroupService.ValidateGroupLimit(groups);
            }
        }
    }
}