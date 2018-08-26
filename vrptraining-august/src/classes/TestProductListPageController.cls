@isTest
public class TestProductListPageController {
    
    @isTest static void MyUnitTest() {
        Product_Table__c gotobase1 = new Product_Table__c(Name='TestPhone1', Unit_Price__c = 100);
        Product_Table__c gotobase2 = new Product_Table__c(Name='TestPhone2', Unit_Price__c = 200, Product_Description__c = 'TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2 TestPhone2');
        insert gotobase1;
        insert gotobase2;
        
        List<Product_Table__c> testproducts = [SELECT ID, Name, Units_Available__c, Unit_Price__c FROM Product_Table__c ORDER BY Unit_Price__c];
        
        PageReference pageRef = Page.ProductListPage;	        
        test.setCurrentPage(pageRef);
        
        // Конструктор
		ProductListPageController controller = new ProductListPageController();
        
       	// Получение списка продуктов
       	System.assertEquals(controller.getProducts().size(), testproducts.size());     
        // System.assertEquals(controller.getProducts(), testproducts);
                
        // Переход к оформлению заказа
        controller.productIDValueFromPage = testproducts[0].ID;
        controller.productIDValueInController = controller.productIDValueFromPage;
        PageReference orderPage = Page.OrderPage;
        orderPage.getParameters().put('id', controller.productIDValueInController);
        orderPage.getParameters().put('retURL', ApexPages.currentPage().getUrl());
        String url1 = controller.RedirectToOrder().getUrl();
        String url2 = orderPage.getUrl();
        url1.equalsIgnoreCase(url2);
        //System.assertEquals(controller.RedirectToOrder().getUrl(), orderPage.getUrl());
        
    }

}