public class DescriptionPageController {
    
    public Product_Table__c product;
       
    public DescriptionPageController() {   
        product = [SELECT ID, Name, Image_Url__c, Title__c, Product_Description__c, Units_Available__c FROM Product_Table__c
                   WHERE ID =: ApexPages.currentPage().getParameters().get('id')];
	}
    
    public Product_Table__c getProduct() {
        return product;
    }
    
    public PageReference RedirectToShop() {
        PageReference page = new PageReference('/apex/ProductListPage');
        page.setRedirect(true);
        
        return page;
    }
    
    public PageReference RedirectToOrder() {
        PageReference page = new PageReference('/apex/OrderPage');
        page.getParameters().put('id', product.Id);
        page.getParameters().put('retURL', ApexPages.currentPage().getUrl());
        page.setRedirect(true);
        
        return page;
    }
}