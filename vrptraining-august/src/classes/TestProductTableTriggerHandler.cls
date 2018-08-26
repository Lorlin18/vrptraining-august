@isTest
public class TestProductTableTriggerHandler {
    
    @isTest static void findOldWarehouse() {
        Product_Table__c testproduct = new Product_Table__c(Name='Test Product', Added_Date__c = System.today() + 3);
        Warehouse__c testwarehouse = new Warehouse__c(Name='Warehouse ' + System.today() + ' ' + System.today() + 20,
                                                      Period_Start__c = System.today(),
                                                      Period_End__c = System.today() + 20);
        insert testwarehouse;
        insert testproduct;
    }
    
    @isTest static void createNewWarehouse() {
        Org_Configuration__c orgConfig = new Org_Configuration__c(Period_Term__c = 20);
        insert orgConfig;
        Product_Table__c testproduct = new Product_Table__c(Name='Test Product', Added_Date__c = System.today() + 3);
        insert testproduct;    
    }
    
    @isTest static void testQuestionMethod() {
        List<Warehouse__c> warehouse_list = new List<Warehouse__c>();
        warehouse_list.add(new Warehouse__c(Name = 'Warehouse 1', Period_Start__c = System.today(),
                                            Period_End__c = System.today() + 10));
        warehouse_list.add(new Warehouse__c(Name = 'Warehouse 12', Period_Start__c = System.today()+15,
                                            Period_End__c = System.today() + 25));
        insert warehouse_list;
        Product_Table__c testproduct = new Product_Table__c(Name='Test', Added_Date__c = System.today() + 500);
        System.assertEquals(true, ProductTableTriggerHandler.doesThisProductNeedsToCreateAWarehouse(testproduct, warehouse_list));
    }
    
}