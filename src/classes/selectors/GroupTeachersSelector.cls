public with sharing class GroupTeachersSelector {
    public static List<Contact> getTeacherFromGroups(Set<Id> teacherIds) {
        return  [SELECT Id, Name FROM Contact WHERE Id = : teacherIds];
    }
}