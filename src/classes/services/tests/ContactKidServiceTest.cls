@IsTest
private class ContactKidServiceTest {

    @IsTest
    static void validateNumberOfKidsPerGroupTest_positive() {
        //given
        Group__c newGroup = TestDtFactory.createGroupWithKidsLimit(15, 0);
        insert newGroup;
        List<Contact> kids = TestDtFactory.createKidsForGroup(10, newGroup.Id);

        //whens
        Test.startTest();
        insert kids;
        Test.stopTest();

        //then
        List<Group__c> result = [SELECT Id, Number_of_kids__c FROM Group__c WHERE Id = :newGroup.Id];
        System.assertEquals(kids.size(), result[0].Number_of_kids__c);
    }

    @IsTest
    static void validateNumberOfKidsPerGroupTest_negative() {
        //given
        Group__c newGroup = TestDtFactory.createGroupWithKidsLimit(15, 15);
        insert newGroup;
        List<Contact> kids = TestDtFactory.createKidsForGroup(1, newGroup.Id);
        Exception ex = null;

        //whens
        Test.startTest();
        try {
            insert kids;
        } catch (Exception e) {
            ex = e;
        }
        Test.stopTest();

        //then
        System.assertNotEquals(null, ex);
        System.assert(ex.getMessage().contains(Label.Group_Limit_is_reached));
        List<Group__c> result = [SELECT Id, Name, Number_of_kids__c FROM Group__c WHERE Id = :newGroup.Id];
        System.assertEquals(newGroup.Number_of_kids__c, result[0].Number_of_kids__c);
    }

    @IsTest
    static void updateAmountOfKidsOnGroupTest() {
        //given
        Group__c newGroup = TestDtFactory.createGroupWithKidsLimit(15, 0);
        insert newGroup;
        List<Contact> kids = TestDtFactory.createKidsForGroup(10, newGroup.Id);

        //whens
        Test.startTest();
        insert kids;
        delete kids[0];
        Test.stopTest();

        //then
        List<Contact> resultKids = [SELECT Id FROM Contact];
        List<Group__c> result = [SELECT Id, Number_of_kids__c FROM Group__c WHERE Id = :newGroup.Id];
        System.assertEquals(resultKids.size(), result[0].Number_of_kids__c);
    }
}