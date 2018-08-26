public class ProductListPageController {
    
    public List<Product_Table__c> product_list;
    public String productIDValueInController {get; set;}
    public String productIDValueFromPage {get; set;}   
       
    public ProductListPageController() {
        
        product_list = Database.query('SELECT ID, Image_Url__c, Name, Title__c, Product_Description__c, Unit_Price__c ' +
                                                             'FROM Product_Table__c ORDER BY Unit_Price__c LIMIT 100');
        
        for(Product_Table__c product : product_list) {
        	if(product.Product_Description__c != null && product.Product_Description__c.length() > 100) {
            	product.Product_Description__c = product.Product_Description__c.substring(0, 100);
        	}     	
    	}
	}
    
    public List<Product_Table__c> getProducts() {
        return product_list;
    }
       
    public PageReference RedirectToOrder() {
        productIDValueInController = productIDValueFromPage;
        PageReference page = new PageReference('/apex/OrderPage');
        page.getParameters().put('id', productIDValueInController);
        page.getParameters().put('retURL', ApexPages.currentPage().getUrl());
        
        return page;
    }
}