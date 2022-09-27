public with sharing class GroupService {
    public static void OneToOneValidateOnInsert (List<Group__c> groups) {
        Map<Id, Contact> mapTeachers = getMapTeachers();
        for (Group__c g : groups) {
            if (mapTeachers.containsKey(g.Teacher__c)) {
                g.addError('A Group already exist for the Teacher - ' + mapTeachers.get(g.Teacher__c).Name);
            }
        }
    }

    public static void OneToOneValidateOnUpdate (List<Group__c> groups, Map<Id,Group__c> groupsOld) {
        Map<Id, Contact> mapTeachers = getMapTeachers();
        for (Group__c g : groups) {
            if (mapTeachers.containsKey(g.Teacher__c) && g.Teacher__c != groupsOld.get(g.Id).Teacher__c) {
                g.addError('A Group already exist for the Teacher - ' + mapTeachers.get(g.Teacher__c).Name);
            }
        }
    }

    private static Set<Id> getTeacherIds() {
        Set<Id> teacherIds = new Set<Id>();
        for (Group__c g : [SELECT Teacher__c FROM Group__c]) {
            teacherIds.add(g.Teacher__c);
        }
        return teacherIds;
    }

    private static Map<Id, Contact> getMapTeachers() {
        Set<Id> teacherIds = getTeacherIds();
        Map<Id, Contact> mapTeachers = new Map<Id, Contact>();
        List<Contact> lstTeachers = GroupTeachersSelector.getTeacherFromGroups(teacherIds);
        if (!lstTeachers.isEmpty()) {
            for (Contact c : lstTeachers) {
                mapTeachers.put(c.Id, c);
            }
        }
        return mapTeachers;
    }
}
