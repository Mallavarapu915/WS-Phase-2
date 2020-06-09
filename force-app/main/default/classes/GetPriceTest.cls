@isTest
private class GetPriceTest {
    
    @testSetup static void setup() {
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Program_Type__c = 'Chefs',
            Account_Level__c = 'Chefs',
            Program_Tier__c = 'Chefs',
            Automatic_Upgrade_Downgrade__c = 'Never',
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
    }
    @isTest static void testDesignerAPI(){
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        
        Test.starttest();
        test.setMock(HttpCalloutMock.class, new DesignerApiMock());
        PageReference pageRef = Page.GetPricePage;
        pageRef.getParameters().put('Id',q.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qliList);        
        GetPriceController testGetPrice = new GetPriceController(stdSetController);
        testGetPrice.getPromocode();
        Test.stopTest();  
        
        //System.assertEquals (null,pageRef);
    }
    @isTest static void testDesignerAPIError(){
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        
        Test.starttest();
        test.setMock(HttpCalloutMock.class, new DesignerApiMock());
        PageReference pageRef = Page.GetPricePage;
        pageRef.getParameters().put('Id',q.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qliList);        
        GetPriceController testGetPrice = new GetPriceController(stdSetController);
        testGetPrice.isPromo='Error:test';
        testGetPrice.checkTheBatchStatus();
        string xml='<?xml version="1.0" encoding="UTF-8" ?> <ns2:OrderPricingResponse version="2.0.0" xmlns:ns2="http://services.wsgc.com/2014/Order"> <SystemContext> <EnvironmentIdentifier>Production</EnvironmentIdentifier> <RegionIdentifier>US</RegionIdentifier> <SourceSystemIdentifier>ECM</SourceSystemIdentifier> <TransactionId>000000084853@2020-03-07T20:53:30.328-08:00</TransactionId> <TransactionTime>2020-03-07T20:53:30.328-08:00</TransactionTime> </SystemContext> <OrderContext conceptCode="WS" omsOrderId="000000084853" type="Designer"> <OrderTime>2020-02-26T10:00:46.000-08:00</OrderTime> </OrderContext> <Promotion id="1"> <Code>FRIENDS </Code> <Status>INVALID</Status> <EffectiveCode>FRIENDS </EffectiveCode> <Specification>FRIENDS </Specification> </Promotion> <SubOrder omsSubOrderId="1"> <Item conceptCode="WS" itemId="2673713" omsLineId="1"> <Quantity>4</Quantity> <Charges> <ChargeSpec>QT=504.66!CG=[BS,D,571.56,0.00]</ChargeSpec> <Charge type="merch"> <Unit>1299.00</Unit> <LineEffective>5196.00</LineEffective> </Charge> <Charge type="shipping"> <Line>571.56</Line> <LineEffective>571.56</LineEffective> </Charge> <Charge type="destination"> <Line>0.00</Line> <LineEffective>0.00</LineEffective> </Charge> <Charge type="surcharge"> <Unit>0.00</Unit> <LineEffective>0.00</LineEffective> </Charge> <Charge type="monogramming"> <Unit>0.00</Unit> <LineEffective>0.00</LineEffective> </Charge> <Charge type="giftwrap"> <Line>0.00</Line> <LineEffective>0.00</LineEffective> </Charge> <Tax type="merch"> <Line>454.65</Line> </Tax> <Tax type="shipping"> <Line>50.01</Line> </Tax> <Tax type="destination"> <Line>0.00</Line> </Tax> <Tax type="surcharge"> <Line>0.00</Line> </Tax> <Tax type="monogramming"> <Line>0.00</Line> </Tax> <Tax type="giftwrap"> <Line>0.00</Line> </Tax> </Charges> </Item> </SubOrder> </ns2:OrderPricingResponse>';
        map<string,double> resp=PricingServiceHelper.responsetoQLI(xml);
        Test.stopTest();  
        
    }
    @isTest static void testDesignerAPIErrorNew(){
        
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        
        Test.starttest();
        test.setMock(HttpCalloutMock.class, new DesignerApiMockError());
        PageReference pageRef = Page.GetPricePage;
        pageRef.getParameters().put('Id',q.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qliList);        
        GetPriceController testGetPrice = new GetPriceController(stdSetController);
        testGetPrice.getPromocode();
        Test.stopTest();  
        
    }
    @isTest static void testGetPrice(){
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        
        String xml ='<sku id="7773633" catalog="19" catalogGeneration="419072255.0" xmlns="http://wsgc.com/ecommerce"';
        xml+='xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"';
        xml+='xsi:schemaLocation="http://wsgc.com/ecommerce https://www.qa21.williams-sonoma.com/services/schemas/catalog-v2.xsd">';
        xml+='<catalogSku>19-1000314</catalogSku>';
        xml+='<name>INT 800ED Breville Espresso Machine</name>';
        xml+='<available>true</available>';
        xml+='<sellable>false</sellable>';
        xml+='<sellableIfNla>false</sellableIfNla>';
        xml+='<displayable>false</displayable>';
        xml+='<backorder>false</backorder>';
        xml+='<price type="special">';
        xml+='<selling>25.00</selling>';
        xml+='<regular>70.00</regular>';
        xml+='<surcharge>11.50</surcharge>';
        xml+='<retail>16.00</retail>';
        xml+='</price>';
        xml+='<merch>';
        xml+='<itemType>REG</itemType>';
        xml+='<dept>113</dept>';
        xml+='<class>3</class>';
        xml+='<subClass>3</subClass>';
        xml+='</merch>';
        xml+='<promotionConstraints>';
        xml+='<constraint>MAP</constraint>';
        xml+='<constraint>ExcludePrice</constraint>';
        xml+='</promotionConstraints>';
        xml+='<inHome>false</inHome>';
        xml+='<directShip>false</directShip>';
        xml+='<taxCategory>1</taxCategory>';
        xml+='<freeShip>false</freeShip>';
        xml+='<freePz>false</freePz>';
        xml+='<furniture>false</furniture>';
        xml+='<priceModifier>Clearance</priceModifier>';
        xml+='<giftWrap>true</giftWrap>';
        xml+='<monogram>false</monogram>';
        xml+='<personalize>false</personalize>';
        xml+='</sku>';
        String jsonContent = XmlParser.xmlToJson(xml);
        list<QuoteLineItem> qlilst=new list<QuoteLineItem>();
        for(QuoteLineItem qli :qliList){
            qli.catalog_response__c=jsonContent;
            qlilst.add(qli);
        }
        update qlilst;
        
        Test.starttest();
        Test.setMock(HttpCalloutMock.class, new CatalogServiceHttpMock());
        Test.setMock(HttpCalloutMock.class, new PricingServiceHttpMock());
        Test.setMock(HttpCalloutMock.class, new DesignerApiMock());
        PageReference pageRef = Page.GetPricePage;
        pageRef.getParameters().put('Id',q.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qlilst);        
        GetPriceController testGetPrice = new GetPriceController(stdSetController);
        testGetPrice.checkTheBatchStatus();
        CatalogErrorHadling.errFlag=true;
        testGetPrice.checkTheBatchStatus();
        Test.stopTest();  
        
        //System.assertEquals (null,pageRef);
    }
    @isTest static void testGetPrice1(){
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        set<id> quoteLineItemIds=new set<id>();
        quoteLineItemIds.add(qliList[0].id);
        Test.starttest();
        Test.setMock(HttpCalloutMock.class, new CatalogServiceHttpMock());
        Test.setMock(HttpCalloutMock.class, new PricingServiceHttpMock());
        Test.setMock(HttpCalloutMock.class, new DesignerApiMock());
        CatalogService catalog = new CatalogService(quoteLineItemIds,q.id);
        //id batchIds = Database.executeBatch(catalog, 5);
        PageReference pageRef = Page.GetPricePage;
        pageRef.getParameters().put('Id',qliList[0].QuoteId);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qliList); 
        GetPriceController testGetPrice = new GetPriceController(stdSetController);
        testGetPrice.checkTheBatchStatus();
        //testGetPrice.batchid=batchIds;
        testGetPrice.checkTheBatchStatus();
        Test.stopTest();  
    }
    @isTest static void errorHandling(){
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        
        Test.starttest();
        CatalogErrorHadling er=new CatalogErrorHadling();
        CatalogErrorHadling.errFlag=true;
        CatalogErrorHadling.errMessage ='test';
        test.setMock(HttpCalloutMock.class, new DesignerApiMock());
        PageReference pageRef = Page.GetPricePage;
        pageRef.getParameters().put('Id',q.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(qliList);        
        GetPriceController testGetPrice = new GetPriceController(stdSetController);
        string xml='<TestXml><Error>error</Error></TestXml>';
        PricingServiceHelper.errorResponse(xml);
        PricingServiceHelper.saveErrorActivity(string.valueOf(qliList[0].QuoteId),'test','test@gmail.com');
        Test.stopTest();  
    }
    @isTest static void CatalogServiceGetCalloutTest(){
        
        Product2[] pList = new List<Product2> {
            new Product2(
                Name = 'GetPriceTestProduct', 
                Product_Sku__c = '7773633')
                };
                    insert pList;
        
        Pricebook2[] pbList = new List<Pricebook2> {
            new Pricebook2(
                Name = 'GetPriceTestPriceBook', 
                IsActive = true)
                };
                    insert pbList;
        
        PricebookEntry[] pbeList = new List<PricebookEntry> {
            new PriceBookEntry(
                Product2Id = pList[0].Id, 
                Pricebook2Id = Test.getStandardPricebookId(), 
                UnitPrice = 0.00,
                IsActive=true),
                
                new PriceBookEntry(
                    Pricebook2Id = pbList[0].Id, 
                    Product2Id = pList[0].Id, 
                    UnitPrice = 149.00, 
                    IsActive = true)
                };
                    insert pbeList;
        
        Account acc = new Account(
            Name = 'CatalogServiceTestingAccount',
            Account_Level__c = 'Chefs', 
            BillingStreet = '105 W Georgianna Dr',
            BillingCity = 'Richboro',   
            BillingState = 'PA',
            BillingPostalCode = '18954',
            BillingCountry = 'US',
            ShippingStreet ='CatalogServiceTestingAccount',
            ShippingCity = '105 W Georgianna Dr',   
            ShippingState ='Richboro',
            ShippingPostalCode  = 'PA',
            ShippingCountry = '18954'); 
        insert acc;
        
        Opportunity opp = new Opportunity(
            Name = 'CatalogServiceTestingOpportunity',
            Concept__c = 'WS',
            AccountId = acc.Id,
            StageName = 'Prospect',
            CustomFieldProductType__c = 'Chefs',
            B_Batch__c = 'No',
            CloseDate = Date.today() + 10);
        insert opp;
        contact con=new contact(lastname='Testcon', Membership_Status__c ='Approved',Assign_Membership_ID__c= true,accountid=acc.id,designer_id__c='110100363452');
        insert con;
        Quote q = new Quote(
            OpportunityId = opp.Id,
            PriceBook2Id = pbList[0].Id, 
            Name = 'GetPriceTestQuote',
            Type_new__c = 'Designer',
            Shipping_Method__c = 'Standard',
            contactid=con.id,
            WSI_Name__c = 'Salesforce');
        //Promo_Code__c = 'FRIENDS');//change this when designer service is used
        insert q;
        QuoteLineItem[] qliList = new List<QuoteLineItem> {
            new QuoteLineItem(
                QuoteId = q.Id, 
                Quantity = 2, 
                PricebookEntryId = pbeList[1].Id, 
                UnitPrice = 149.00)
                };
                    insert qliList;
        
        Test.starttest();
        Set<Id> qliids=new set<id>();
        for(QuoteLineItem qli:qliList){
            qliids.add(qli.id);
        }
        test.setMock(HttpCalloutMock.class, new CatalogServiceHttpMock());
        database.executeBatch(new CatalogServiceGetCallout(qliids));
        Test.stopTest();  
    }
}