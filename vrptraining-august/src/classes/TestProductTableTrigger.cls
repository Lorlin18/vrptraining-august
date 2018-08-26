@isTest
public class TestProductTableTrigger {
    
    @isTest static void insertProductTable() {
        Org_Configuration__c orgConfig = new Org_Configuration__c(Period_Term__c = 20);
        insert orgConfig;
        List<Product_Table__c> product_list = new List<Product_Table__c>();
        for(integer i=0; i < 5; i++) {
            product_list.add(new Product_Table__c(Name='Test Product', Added_Date__c = System.today() + 20*i));
			product_list.add(new Product_Table__c(Name ='Test'));            
        }
        insert product_list;        
    }
    
    @isTest static void insertProductTableWithoutAddedDate() {
		Org_Configuration__c orgConfig = new Org_Configuration__c(Period_Term__c = 20);
        insert orgConfig;
        Product_Table__c productWithEmptyAddedDate = new Product_Table__c(Name='Test');
        insert productWithEmptyAddedDate;
    }
    
}