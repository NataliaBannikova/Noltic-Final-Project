@IsTest
private class GroupServiceTest {

    @IsTest
    static void OneToOneValidateOnInsertTest_positive() {
        //given
        Group__c newGroup = TestDtFactory.createGroupWithTeacher();

        //whens
        Test.startTest();
        insert newGroup;
        Test.stopTest();

        //then
        List<Group__c> result = [SELECT Id FROM Group__c];
        System.assertEquals(1, result.size());
    }

    @IsTest
    static void OneToOneValidateOnInsertTest_negative() {
        //given
        Contact teacher = TestDtFactory.createContactRecordTypeTeacher();
        insert teacher;
        Group__c newGroup = TestDtFactory.createGroup(teacher.Id);
        insert newGroup;
        Group__c nextGroup = TestDtFactory.createGroup(teacher.Id);
        Exception ex = null;

        //whens
        Test.startTest();
        try {
            insert nextGroup;
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();

        //then
        System.assertNotEquals(null, ex);
        System.assert(ex.getMessage().contains(Label.Group_already_exist_for_the_Teacher));
        List<Group__c> result = [SELECT Id FROM Group__c];
        System.assertEquals(1, result.size());
    }

    @IsTest
    static void OneToOneValidateOnUpdateTest() {
        //given
        Contact teacher = TestDtFactory.createContactRecordTypeTeacher();
        insert teacher;
        Group__c newGroup = TestDtFactory.createGroup(teacher.Id);
        insert newGroup;

        Contact newTeacher = TestDtFactory.createContactRecordTypeTeacher();
        insert newTeacher;
        Group__c nextGroup = TestDtFactory.createGroup(newTeacher.Id);
        insert nextGroup;
        nextGroup.Teacher__c = teacher.Id;

        Exception ex = null;

        //whens
        Test.startTest();
        try {
            update nextGroup;
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();

        //then
        System.assertNotEquals(null, ex);
        System.assert(ex.getMessage().contains(Label.Group_already_exist_for_the_Teacher));
        List<Group__c> result = [SELECT Teacher__c FROM Group__c];
        System.assertNotEquals(result[0].Teacher__c, result[1].Teacher__c);
    }
}