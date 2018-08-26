public class ProductTableTriggerHandler {
    
    public static void searchWarehouseBeforeInsert(List<Product_Table__c> product_list) {
        
        for(integer i=0; i < product_list.size(); i++) {
            if(product_list[i].Added_Date__c == null) {
               product_list[i].Added_Date__c = System.today(); 
            }
        }
        
		String queryString = 'SELECT ID, Name, Period_Start__c, Period_End__c FROM Warehouse__c WHERE ';
        for(integer i=0; i < product_list.size(); i++) {
            Date TemporaryDateOfEachProduct = product_list[i].Added_Date__c;
            queryString += '(Warehouse__c.Period_Start__c <= ' + String.valueof(TemporaryDateOfEachProduct) + ' AND Warehouse__c.Period_End__c >= ' + String.valueof(TemporaryDateOfEachProduct) + ') OR ';            
        }
        queryString = queryString.substringBeforeLast('OR');
        //queryString += 'LIMIT ' + String.valueOf(product_list.size());
        List<Warehouse__c> validWarehouses = Database.query(queryString);
        
        System.debug('Amount of valid warehouses: ' + validWarehouses.size());
        
        List<Warehouse__c> newWarehousesList = new List<Warehouse__c>();
        Org_Configuration__c orgConfig = Org_Configuration__c.getInstance();
        
        for(Product_table__c product : product_list) {
            if(doesThisProductNeedsToCreateAWarehouse(product, validWarehouses)) {
                System.debug('Creating new warehouse');
            	Warehouse__c newWarehouse = new Warehouse__c(Name = 'Warehouse ' + product.Added_Date__c.format() + ' ' + (product.Added_Date__c + (Integer)orgConfig.Period_Term__c).format(),
                                                        Period_Start__c = product.Added_Date__c,
                                                        Period_End__c = product.Added_Date__c + (Integer)orgConfig.Period_Term__c);
                newWarehousesList.add(newWarehouse);
                validWarehouses.add(newWarehouse);
            }
        }
        
        insert newWarehousesList;
        
        for(Product_Table__c product : product_list) {
            for(Warehouse__c currentWarehouse : validWarehouses) {
				if(currentWarehouse.Period_Start__c <= product.Added_Date__c &&
				   currentWarehouse.Period_End__c >= product.Added_Date__c) {
					product.Warehouse__c = currentWarehouse.ID;
					System.debug('The product has been assigned warehouse ' + currentWarehouse.ID);
					break;
            	}                
            }
        }       
    }
    
    public static boolean doesThisProductNeedsToCreateAWarehouse(Product_Table__c product, List<Warehouse__c> warehouses) {
        boolean need = true;
        if(warehouses.size() > 0) {
        	for(Warehouse__c warehouse : warehouses) {
            	if(warehouse.Period_Start__c <= product.Added_Date__c &&
			  	   warehouse.Period_End__c >= product.Added_Date__c) {
                  	need = false;
                    System.debug('The product does not need a new warehouse');
                  	break;
              	}
        	}            
        }
        return need;
    }    
}