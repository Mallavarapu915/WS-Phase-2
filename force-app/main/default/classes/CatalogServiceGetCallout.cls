global class CatalogServiceGetCallout implements Database.Batchable<sObject>, Database.AllowsCallouts {
    private Catalog_And_Pricing_Configurations__mdt config;
    private Set<Id> quoteLineItemIds;
    private Set<Id> cquoteLineItemIds;
    
    public CatalogServiceGetCallout(Set<Id> quoteLineItemIds){
        
        this.quoteLineItemIds = quoteLineItemIds;
        config=new Catalog_And_Pricing_Configurations__mdt();
        config=GetPriceController.getMetadata();
        cquoteLineItemIds=new set<id>();
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator('SELECT Id,concept__c,SKU__c,Gift_Wrap_eligible__c,Monogram_eligible__c,Personalize_eligible__c FROM QuoteLineItem WHERE Id IN :quoteLineItemIds'); 
    }
    
    global void execute(Database.BatchableContext bc, List<QuoteLineItem> records){
        
        Catalog_And_Pricing_Configurations__mdt config=new Catalog_And_Pricing_Configurations__mdt();
        Set<Id> quoteLineItemIds;
        Id quoteId;
        Set<Id> cquoteLineItemIds; 
        cquoteLineItemIds=new set<id>();
        config=GetPriceController.getMetadata();
        List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>();
        String httpQLIResponse;
        
        for(QuoteLineItem quoteLineItem : records){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint;
            system.debug('concept====='+quoteLineItem.Concept__c);
            if(quoteLineItem.Concept__c=='WS')
                endpoint= string.format(config.Catalog_EndPoint__c,new list<string>{quoteLineItem.sku__c});
            if(quoteLineItem.Concept__c=='MG')
                endpoint= string.format(config.Catalog_EndPoint_MG__c,new list<string>{quoteLineItem.sku__c});
            if(quoteLineItem.Concept__c=='PB')
                endpoint= string.format(config.Catalog_EndPoint_PB__c ,new list<string>{quoteLineItem.sku__c});
            if(quoteLineItem.Concept__c=='PK')
                endpoint= string.format(config.Catalog_EndPoint_PK__c ,new list<string>{quoteLineItem.sku__c});
            if(quoteLineItem.Concept__c=='PT')
                endpoint= string.format(config.Catalog_EndPoint_PT__c,new list<string>{quoteLineItem.sku__c});
            if(quoteLineItem.Concept__c=='WE')
                endpoint= string.format(config.Catalog_EndPoint_WE__c,new list<string>{quoteLineItem.sku__c});
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            Blob headerValue = Blob.valueOf(config.Username__c + ':' + config.password__c);
            String authorizationHeader = 'Basic ' +
                EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            HttpResponse response = http.send(request);
            httpQLIResponse = String.valueof(response);
            System.debug('***** Status ***** ' + response.getBody());
            
            if (response.getStatusCode() == 200) {
                String xmltoJSONresponse;
                xmltoJSONresponse = XMLParser.xmlToJson(response.getBody());
                Map<String, Object> parser = (Map<String, Object>) JSON.deserializeUntyped(xmltoJSONresponse);
                Map<String, Object> jobParser = (Map<String, Object>) parser.get('sku');
                System.debug('********** jobParser1 : '+boolean.valueOf(jobParser.get('giftWrap')));
                System.debug('********** jobParser2:   '+ boolean.valueOf(jobParser.get('monogram')));
                System.debug('********** jobParser3 :  '+boolean.valueOf(jobParser.get('personalize')));
                If(boolean.valueOf(jobParser.get('giftWrap')) == True)
                    quoteLineItem.Gift_Wrap_eligible__c=True;
                    //quoteLineItem.Gift_Wrap_VAS__c = False;
                If(boolean.valueOf(jobParser.get('monogram')) == True)
                    quoteLineItem.Monogram_eligible__c=True;
                    //quoteLineItem.Monogram_VAS__c = False;
                If(boolean.valueOf(jobParser.get('personalize')) == True)
                    quoteLineItem.Personalize_eligible__c=True;
                    quoteLineItem.Personalize_VAS__c = False;
                System.debug('*******  quoteLineItem.Gift_Wrap_eligible__c ' + quoteLineItem.Gift_Wrap_eligible__c+ ' '+quoteLineItem.Monogram_eligible__c  +' '+quoteLineItem.Personalize_eligible__c);
                quoteLineItemList.add(quoteLineItem);  
                System.debug('****** quoteLineItemList ****' + quoteLineItemList);
                CatalogErrorHadling.errFlag=false;
                CatalogErrorHadling.errMessage='Success';
                cquoteLineItemIds.add(quoteLineItem.id);
                //System.debug('***** Body ***** ' + response.getBody());
            } 
            else{
                system.debug('catalog error=='+response.getBody());
                CatalogErrorHadling.errFlag=true;
                CatalogErrorHadling.errMessage='Error:'+response.getBody();
            }
            
        }  
        
        if(!quoteLineItemList.isEmpty() && !test.isRunningTest()){
            upsert quoteLineItemList;        
        }
    }
    global void finish(Database.BatchableContext bc){
        //PricingServiceHelper.callPricingService(quoteid,quoteLineItemIds);
    }   
}