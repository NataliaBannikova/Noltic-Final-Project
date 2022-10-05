@IsTest
private class CreateVisitControllerTest {
    @IsTest
    static void getKids() {
        //given
        Group__c gr = TestDtFactory.createGroupWithKidsLimit(10, 0);
        insert gr;
        List<Contact> kids = TestDtFactory.createKidsForGroup(5, gr.Id);
        insert kids;

        //when
        Test.startTest();
        List<Contact> result = CreateVisitController.getKids();
        Test.stopTest();

        //then
        System.assertEquals(kids.size(), result.size());
    }

    @IsTest
    static void getRelatives() {
        //given
        Group__c gr = TestDtFactory.createGroupWithKidsLimit(10, 3);
        insert gr;
        List<Contact> kids = TestDtFactory.createKidsForGroup(1, gr.Id);
        insert kids;
        Contact relative = TestDtFactory.createContactRecordTypeRelative();
        insert relative;
        Responsible_Person__c responsiblePerson = TestDtFactory.createResponsiblePerson(relative.Id);
        insert responsiblePerson;
        KidsToResponsiblePersons__c junctionObj = TestDtFactory.createKidsToResponsiblePersons(kids[0].Id, responsiblePerson.Id);
        insert junctionObj;

        //when
        Test.startTest();
        List<Contact> relatives = CreateVisitController.getRelatives(kids[0].Id);
        Test.stopTest();

        //then
        System.assertEquals(1, relatives.size());
    }
}