trigger GroupTrigger on Group__c (before insert, before update) {
    GroupTriggerHandler.handler(Trigger.new, Trigger.oldMap, Trigger.operationType);
}