@isTest
public class TestOrderPageController {

    @isTest static void MyUnitTest() {
        Product_Table__c gotobase = new Product_Table__c(Name='TestPhone', Unit_Price__c = 100, Units_Available__c = 10);
        insert gotobase;
        
        Product_Table__c testproduct = [SELECT ID, Name, Units_Available__c, Unit_Price__c FROM Product_Table__c WHERE Name='TestPhone'];
        
        PageReference pageRef = Page.OrderPage;	        
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testproduct.Id);
        ApexPages.currentPage().getParameters().put('retUrl', 'https://www.google.com');
        
        // Конструктор
        OrderPageController controller = new OrderPageController();
        
       	// Получение продукта
        System.assertEquals(controller.getProduct(), testproduct);
        
        // Товаров нет на складе (контакт уже существует)
        Contact testcontact = new Contact(FirstName = 'Иван', LastName = 'Иванов', Email = 'ivanov@mail.ru');
        insert testcontact;
        
        controller.Email = 'ivanov@mail.ru';
        controller.FirstNameOnPage ='Иван';
        controller.LastNameOnPage = 'Петров';
        controller.UnitsOnPage = 11;                  
        System.assertEquals(null, controller.save());
        
        //Товары есть на складе (контакта не существует)      
        controller.Email = 'petrov@mail.ru';
        controller.FirstNameOnPage ='Александр';
        controller.LastNameOnPage = 'Петров';
        controller.UnitsOnPage = 8;
        
        PageReference successPage = new PageReference('/apex/SuccessPage');
        String url1 = controller.save().getUrl();
        String url2 = successPage.getUrl();
        url1.equalsIgnoreCase(url2);
        
        //Поиск контакта при вводе
        controller.Email = 'ivanov@mail.ru';
        controller.SearchContactToAutoFill();
        System.assertEquals(controller.FirstNameOnPage, 'Иван');
        controller.Email = '';
        controller.SearchContactToAutoFill();
        System.assertEquals(controller.FirstNameOnPage, '');
        
        //Обновление существующего контакта
        controller.Email = 'ivanov@mail.ru';
        controller.FirstNameOnPage ='Иван';
        controller.LastNameOnPage = 'Петров';
        controller.UnitsOnPage = 1;
        PageReference success = new PageReference('/apex/SuccessPage');
        String url3 = controller.save().getUrl();
        String url4 = success.getUrl();
        url3.equalsIgnoreCase(url4); 

        // Все возможные ошибки
        controller.Email = '';
        System.assertEquals(null, controller.save());
        controller.Email = 'testtesttest@mail.ru';
        controller.FirstNameOnPage = 'Иван';
        controller.LastNameOnPage = null;
        System.assertEquals(null, controller.save());
        controller.Email = 'newmail@gmail.com';
        controller.FirstNameOnPage = 'Иван';
        controller.LastNameOnPage = 'Иванов';
        controller.UnitsOnPage = null;
        System.assertEquals(null, controller.save());    
        
        // Стоимость заказа
        controller.UnitsOnPage = 2;
        controller.total();
        System.assertEquals(200, controller.TotalAmount);
                
        // Предыдущая страница
        System.assertEquals(controller.back().getUrl(), ApexPages.currentPage().getParameters().get('retURL'));
        
    }
}