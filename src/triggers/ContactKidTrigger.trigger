trigger ContactKidTrigger on Contact (before insert, before update, after insert, after update, after delete) {
    ContactKidTriggerHandler.handler(Trigger.new, Trigger.old, Trigger.operationType);
}