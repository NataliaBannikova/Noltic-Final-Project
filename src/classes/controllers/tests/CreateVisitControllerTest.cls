@IsTest
private class CreateVisitControllerTest {
    public static final Id CONTACT_RECORD_TYPE_RELATIVE_ID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Relative').getRecordTypeId();
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
        Contact relative = new Contact(LastName='Test', MobilePhone= '1234567891', RecordTypeId= CONTACT_RECORD_TYPE_RELATIVE_ID);
        insert relative;
        Responsible_Person__c rp = new Responsible_Person__c(Contact__c = relative.Id);
        insert rp;
        KidsToResponsiblePersons__c junctionObj = new KidsToResponsiblePersons__c(Kid__c = kids[0].Id, Responsible_Person__c = rp.Id);
        insert junctionObj;

        //when
        Test.startTest();
        List<Contact> relatives = CreateVisitController.getRelatives(kids[0].Id);
        Test.stopTest();

        //then
        System.assertEquals(1, relatives.size());
    }
}