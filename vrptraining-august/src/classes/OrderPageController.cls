public with sharing class OrderPageController {
    
    public Integer UnitsOnPage {get; set;}
    public String Email {get; set;}
    public String EmailToSearch {get; set;}
    public Decimal TotalAmount {get; set;}
    public String FirstNameOnPage {get; set;}
    public String LastNameOnPage {get; set;}
    
    public Product_Table__c product;
    List<Contact> tryToFindContact;
    public Contact client;
    	
    public OrderPageController() {   
        product = [SELECT ID, Name, Units_Available__c, Unit_Price__c FROM Product_Table__c
                   WHERE ID =: ApexPages.currentPage().getParameters().get('id')];
        total();
	}
    
    public void SearchContactToAutoFill() {
		EmailToSearch = Email;
        if(EmailToSearch != '') {
			tryToFindContact = [SELECT FirstName, LastName FROM CONTACT WHERE Email=:EmailToSearch];
        		if(!tryToFindContact.isEmpty()) {
        		FirstNameOnPage = tryToFindContact[0].FirstName;
				LastNameOnPage = tryToFindContact[0].LastName; 
        	} 	    			            
        } else {
            FirstNameOnPage = '';
            LastNameOnPage = '';
        }                 
    }
    
    public Product_Table__c getProduct() {
        return product;
    }
    
    public PageReference save() {
        PageReference finalPage;
        if(checkErrors()) {
          	finalPage = null;
        } else {
        	client = searchContact(Email, FirstNameOnPage, LastNameOnPage);       
			newOrderTable(client, product, UnitsOnPage);
            finalpage = new PageReference('/apex/SuccessPage');
            finalpage.setRedirect(true);
        }
        return finalPage;
    }
    
    public boolean checkErrors() {
       if(Email == null || Email == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Please enter email value'));
            return true;
        } else if(FirstNameOnPage == null || FirstNameOnPage == '' || LastNameOnPage == null || LastNameOnPage == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Please enter your full name'));
            return true;
        } else if(UnitsOnPage == null || UnitsOnPage <= 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'Invalid quantity of product'));
            return true;            
        } else if(UnitsOnPage > product.Units_Available__c) {
            String maxCount = product.Units_Available__c + '';
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There is only ' + maxCount + ' units of product on warehouse.'));
            return true;
        } else {
            return false;
        }
    }
    
   	public Contact searchContact(String email, String new_first_name, String new_last_name) {
        List<Contact> result = [SELECT ID, FirstName, LastName, Email FROM Contact WHERE Email =:email LIMIT 1];
              
        if(!result.isEmpty()) {
            System.debug('Контакт найден. Обновим контакт');
            result[0].FirstName = new_first_name;
            result[0].LastName = new_last_name;
            
            update result[0];
            return result[0];
        } else {
            System.debug('Контакт не найден. Создадим новый контакт');
            Contact client = new Contact(FirstName = new_first_name, LastName = new_last_name, Email = email);
            insert client;
            return client;
        }
    }

    public void newOrderTable(Contact client, Product_Table__c product, Integer units) {
        System.debug('Оформляем заказ');
        Order_Table__c newOrder = new Order_Table__c(Product__c = product.ID, Units__c = units, 
                                                     Order_Amount__c = units * product.Unit_Price__c, Contact__c = client.ID);
        if(decreaseUnitsAvailable(product, UnitsOnPage, client)) {           
            insert newOrder;
            update product;
        }
    }
    
    public boolean decreaseUnitsAvailable(Product_Table__c product, Integer units_to_order, Contact client) {
        boolean canContinue;
       	product.Units_Available__c = product.Units_Available__c - units_to_order;
        if(product.Units_Available__c >= 0) {
            canContinue = true;            
        }
        return canContinue;
    }    
       
    public void total() {
        if(UnitsOnPage < 0 || UnitsOnPage == null) {
            TotalAmount = 0;
        } else {
        	TotalAmount = UnitsOnPage * product.Unit_Price__c;            
        }
    }
    
    public PageReference back() {
		PageReference previousPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        return previousPage;
    }
}