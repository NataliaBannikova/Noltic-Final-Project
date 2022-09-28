public with sharing class ContactKidTriggerHandler {
    public static void handler(List<Contact> contacts, List<Contact> contactsOld, System.TriggerOperation triggerOperation) {
        switch on triggerOperation {
            when BEFORE_INSERT {
                ContactKidService.validateNumberOfKidsPerGroup(contacts);
            }
            when BEFORE_UPDATE {
                ContactKidService.validateNumberOfKidsPerGroup(contacts);
            }
            when AFTER_INSERT {
                ContactKidService.updateAmountOfKidsOnGroup(contacts);
            }
            when AFTER_UPDATE {
                ContactKidService.updateAmountOfKidsOnGroup(contacts);
            }
            when AFTER_DELETE {
                ContactKidService.updateAmountOfKidsOnGroup(contactsOld);
            }
        }
    }
}