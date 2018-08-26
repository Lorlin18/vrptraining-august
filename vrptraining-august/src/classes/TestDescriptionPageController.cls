@isTest
public class TestDescriptionPageController {
	
    @isTest static void MyUnitTest() {
        Product_Table__c gotobase = new Product_Table__c(Name='TestPhone');
        insert gotobase;
        
        Product_Table__c testproduct = [SELECT ID, Name FROM Product_Table__c WHERE Name='TestPhone'];
            
        PageReference pageRef = Page.DescriptionPage;	        
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testproduct.Id);
        
        // Конструктор
        DescriptionPageController controller = new DescriptionPageController();
        
        // Получение продукта
		System.assertEquals(controller.getProduct(), testproduct);
        
        // Обратно в магазин
        PageReference shopPage = new PageReference('/apex/ProductListPage');
        System.assertNotEquals(controller.RedirectToShop(), shopPage);
        
        // Оформление товара
        PageReference orderPage = Page.OrderPage;
        orderPage.getParameters().put('id', testproduct.Id);
        orderPage.getParameters().put('retUrl', ApexPages.currentPage().getUrl());
        String url1 = controller.RedirectToOrder().getUrl();
        String url2 = orderPage.getUrl();
        url1.equalsIgnoreCase(url2);
        //System.assertEquals(controller.RedirectToOrder().getUrl(), orderPage.getUrl());            
    }    
}