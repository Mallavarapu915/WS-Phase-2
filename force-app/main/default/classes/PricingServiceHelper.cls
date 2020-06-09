public class PricingServiceHelper {
    public static pagereference callPricingService(string quoteid,set<id> updatedqli){
        list<quotelineitem> allQli=new list<quotelineitem>();
        Catalog_And_Pricing_Configurations__mdt config=GetPriceController.getMetadata();        
        for(quotelineitem qlis:[select id,quantity,Catalog_Response__c,SKU__c,UnitPrice,Discount__c,Total_Merch__c,Unit_Destination__c,Total_Destination__c,
                                Tax_Destination__c,Tax_Gift_Wrap__c,Tax_Merch__c,Tax_Mono_Logo__c,Tax_Shipping__c,Tax_Surcharge__c,Unit_Surcharge__c,Total_Surcharge_New__c,Mono_LogoPeritem__c,Total_Mono_Logo_New__c,Unit_Gift_Wrap__c,Total_Gift_Wrap_New__c,Gift_Wrap_VAS__c,Personalize_VAS__c,Monogram_VAS__c from quotelineitem where quoteid=:quoteid]){
                                    if(qlis.Catalog_Response__c!=null)
                                        allQli.add(qlis);
                                }
        system.debug('allQli==='+allQli);
        if(allQli.isEmpty())
            return null;
        quote qt=new quote();
        qt=[select id,Promo_Code__c,Merch__c,Shipping__c,Tax,Destination__c,Surcharge_New__c,Gift_Wrap_New__c,MonoLogo_New__c,createddate,Shipping_Method__c,opportunity.Concept__c,quotenumber,Member_ID__c,Type_new__c, BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Shippingcity,Shippingcountry,Shippingstate,Shippingstreet,Shippingpostalcode  from quote where id=:quoteid];
        list<string> PricingSystemContext =new list<string>();
        list<string> PricingOrderContext =new list<string>();
        list<string> PricingFeatures =new list<string>();
        list<string> PricingShipTo=new list<string>();
        list<string> PricingPromotion=new list<string>();
        
        /*Datetime StartDT = system.now();
system.debug('StartDT (local time): ' + StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss'));
string modStartDT = StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss','America/New_York'); 
*/
        
        PricingSystemContext =new list<string>{config.Environment_Identifier__c,config.RegionIdentifier__c,config.SourceSystemIdentifier__c ,qt.quotenumber+(system.now()).format('yyyy-MM-dd\'T\'HH:mm:ss','America/New_York'),(system.now()).format('yyyy-MM-dd\'T\'HH:mm:ss','America/New_York'),string.valueOf(config.TestingMode__c)};
            //'WS','392752912288' 
            PricingOrderContext =new list<string>{qt.opportunity.Concept__c,qt.QuoteNumber,qt.Type_new__c,(system.now()).format('yyyy-MM-dd\'T\'HH:mm:ss','America/New_York'),qt.Member_ID__c,qt.BillingStreet,qt.BillingCity,qt.BillingState,qt.BillingPostalCode,qt.BillingCountry,config.Billing_Verification_Status__c,config.Billing_Classification__c };
                PricingFeatures =new list<string>{(config.IncludeAllCharges__c?'true':'false'),(config.IncludeAllCharges__c?'true':'false'),(config.IncludeSubOrderTotals__c?'true':'false'),(config.IncludeOrderTotals__c?'true':'false') };
                    PricingShipTo =new list<string>{qt.ShippingStreet,qt.ShippingCity,qt.ShippingState,qt.ShippingPostalCode,qt.ShippingCountry,config.ShippingVerificationStatus__c,config.ShippingClassification__c,qt.Shipping_Method__c};
                        PricingPromotion=new list<string>{config.Id__c,qt.Promo_Code__c};
                            string PricingItem='';
        //system.label.PricingItem
        CatalogResponseInfo catResp=new CatalogResponseInfo();
        integer j=1;
        for(QuoteLineItem qli:allQli){
            PricingItem+=createCatalogItem(qli,qt,j); 
            j++;
        }
        system.debug('promo=='+string.isBlank(qt.Promo_Code__c));
        string xljsn=PricingRequest.getPricingRequest(PricingSystemContext,PricingOrderContext,PricingFeatures,PricingShipTo,PricingPromotion,PricingItem,string.isBlank(qt.Promo_Code__c));
        xljsn=xljsn.replace('null','');
        system.Debug('request==='+xljsn);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(config.pricing_endpoint__C);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/xml');
        request.setBody(xljsn);            
        HttpResponse response = http.send(request);
        system.debug('response=='+response.getbody());
        if(response.getStatusCode()!=200){
            CatalogErrorHadling.errFlag=true;
            CatalogErrorHadling.errMessage='Error:'+response.getBody();
            saveErrorActivity(quoteid,response.getBody(),config.Exception_email__c);
            return null;
        }
        else if(response.getBody().contains('Error')){
            CatalogErrorHadling.errFlag=true;
            CatalogErrorHadling.errMessage='Error:'+errorResponse(response.getBody());
            saveErrorActivity(quoteid,errorResponse(response.getBody()),config.Exception_email__c);
            return null;
        } 
        map<string,double> qtandQliMap=responsetoQLI(response.getBody());
        //{7773633:destination:Line=0.0, 7773633:giftwrap:Line=0.0, 7773633:merch:Unit=1299.0, 7773633:monogramming:Unit=0.0, 7773633:shipping:Line=0.0, 7773633:surcharge:Unit=0.0}
        list<QuoteLineItem> updateqli=new list<QuoteLineItem>();
        try{
            integer i=1;
            for(QuoteLineItem qli:allQli){
                if(updatedqli.contains(qli.Id)){}
                qli.unitprice=(qtandQliMap.get(i+''+qli.SKU__c+':merch:Unit')==null?0:qtandQliMap.get(i+''+qli.SKU__c+':merch:Unit')); 
                qli.Unit_Destination__c=qtandQliMap.get(i+''+qli.SKU__c+':destination:Line');
                qli.Unit_Surcharge__c=qtandQliMap.get(i+''+qli.SKU__c+':surcharge:Unit');  
                qli.Mono_LogoPeritem__c=qtandQliMap.get(i+''+qli.SKU__c+':monogramming:Unit');
                qli.Unit_Gift_Wrap__c=qtandQliMap.get(i+''+qli.SKU__c+':giftwrap:Line');
                qli.Unit_Shipping__c=qtandQliMap.get(i+''+qli.SKU__c+':shipping:Line');
                qli.Discount__c =qtandQliMap.get(i+''+qli.SKU__c+':Discount:Unit');
                
                
                qli.Total_Merch__c=qtandQliMap.get(i+''+qli.SKU__c+':merch:LineEffective');
                qli.Total_Destination__c=qtandQliMap.get(i+''+qli.SKU__c+':destination:LineEffective');             
                qli.Total_Surcharge_New__c=qtandQliMap.get(i+''+qli.SKU__c+':surcharge:LineEffective');
                qli.Total_Mono_Logo_New__c=qtandQliMap.get(i+''+qli.SKU__c+':monogramming:LineEffective');
                qli.Total_Gift_Wrap_New__c=qtandQliMap.get(i+''+qli.SKU__c+':giftwrap:LineEffective');
                qli.Total_Shipping__c=qtandQliMap.get(i+''+qli.SKU__c+':shipping:LineEffective'); 
                
                //Tax_Destination__c,Tax_Gift_Wrap__c,Tax_Merch__c,Tax_Mono_Logo__c,Tax_Shipping__c,Tax_Surcharge__c,
                qli.Tax_Merch__c=qtandQliMap.get(i+''+qli.SKU__c+':Tax:merch:Line');
                qli.Tax_Destination__c=qtandQliMap.get(i+''+qli.SKU__c+':Tax:destination:Line');            
                qli.Tax_Surcharge__c=qtandQliMap.get(i+''+qli.SKU__c+':Tax:surcharge:Line'); 
                qli.Tax_Mono_Logo__c=qtandQliMap.get(i+''+qli.SKU__c+':Tax:monogramming:Line');  
                qli.Tax_Gift_Wrap__c=qtandQliMap.get(i+''+qli.SKU__c+':Tax:giftwrap:Line');  
                qli.Tax_Shipping__c=qtandQliMap.get(i+''+qli.SKU__c+':Tax:shipping:Line');  
                updateqli.add(qli); 
                i++;
            }
            qt.Merch__c =qtandQliMap.get('quote:merch');            
            qt.Shipping__c =qtandQliMap.get('quote:shipping');            
            qt.Destination__c =qtandQliMap.get('quote:destination');            
            qt.Surcharge_New__c =qtandQliMap.get('quote:surcharge');            
            qt.Gift_Wrap_New__c =qtandQliMap.get('quote:giftwrap');            
            qt.MonoLogo_New__c =qtandQliMap.get('quote:monogramming');            
            qt.tax =qtandQliMap.get('quote:tax');  
            system.debug('before update===='+updateqli);
            if(!test.isRunningTest()){
                if(!updateqli.isEmpty())
                    update updateqli;
                update qt;                            
            } 
            
        }
        catch(System.CalloutException e){
            CatalogErrorHadling.errFlag=true;
            CatalogErrorHadling.errMessage='Error:'+e.getMessage();
            return null;
        }
        CatalogErrorHadling.errFlag=false;
        CatalogErrorHadling.errMessage='Success';
        return new pagereference('/' + quoteId);
    }
    public static string createCatalogItem(quotelineitem qli,quote qt,integer i){
        string xml = '';
        if(test.isRunningTest())
            qli.Catalog_Response__c=(qli.Catalog_Response__c).replace('\"','"');
        qli.Catalog_Response__c = (qli.Catalog_Response__c).replace( '\\', '\\' );
        CatalogResponseInfo catalog = CatalogResponseInfo.parse(qli.Catalog_Response__c); 
        // System.debug('catalog ***********'+catalog);
        If(qli.Gift_Wrap_VAS__c == True)
            xml ='<Gift>';        
        xml+='<Item conceptCode="'+qt.opportunity.Concept__c+'" itemId="'+qli.SKU__c+'" omsLineId="'+i+'">'+
            '<Master>' + 
            '<TypeCode>' + catalog.sku.merch.itemType + '</TypeCode>' + 
            '<Hierarchy>' + 
            '<DepartmentCode>' + catalog.sku.merch.dept +'</DepartmentCode>' +
            '<ClassCode>' + catalog.sku.merch.className  + '</ClassCode>' +
            '<SubclassCode>' +  catalog.sku.merch.subClass + '</SubclassCode>' +
            '</Hierarchy>' + 
            '<IsInHome>' + catalog.sku.inHome + '</IsInHome>' +
            '<IsDirectShip>' + catalog.sku.directShip + '</IsDirectShip>' +
            '<TaxCategoryCode>' + catalog.sku.taxCategory + '</TaxCategoryCode>';          
        //PromotionConstraint tags are not required while building Pricing request if no PromotionConstraints are available in Catalog response
        if(catalog.sku.promotionConstraints != null && !(catalog.sku.promotionConstraints).isEmpty()){
            for(integer k=0;k<=catalog.sku.promotionConstraints.size()-1;k++){ 
                xml+='<PromotionConstraint>' + catalog.sku.promotionConstraints[k]  + '</PromotionConstraint>';
            }
        }
        xml+= '</Master>' ;
        xml+='<Pricing>' +
            '<Price type="unit" modifier="'+ catalog.sku.priceModifier+'">' + catalog.sku.price.selling + '</Price>' +
            '<Price type="unitFull">' + catalog.sku.price.regular+ '</Price>'; 
        
        //IF(catalog.sku.price.surcharge==null)
        xml+='<Price type="surcharge">' + (catalog.sku.price.surcharge==null ?'0':catalog.sku.price.surcharge) + '</Price>';
        xml+='<IsFreeShip>' + catalog.sku.freeShip + '</IsFreeShip>' +
            '<IsFreePz>' + catalog.sku.freePz + '</IsFreePz>' +
            '</Pricing>'; 
        If(qli.Gift_Wrap_VAS__c==True)
            xml+='<ValueAddedService type="giftwrap"/>';
        If(qli.Personalize_VAS__c==True)
            xml+='<ValueAddedService type="personalization"/>';
        If(qli.Monogram_VAS__c==True)
            xml+='<ValueAddedService type="monogramming"/>';        
        xml+='<Quantity>' + qli.quantity.setscale(0)+ '</Quantity></Item>'; 
        If(qli.Gift_Wrap_VAS__c == True)
            xml+= '</Gift>';
        System.debug('xml*******'+xml);
        return xml;
    }
    public static map<string,double> responsetoQLI(string xml){
        map<string,double> unitandTotal=new map<string,double>();
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Dom.XMLNode node = doc.getRootElement();
        List<Dom.XMLNode> children = node.getChildElements();
        for ( Dom.XMLNode child : children ){
            if(child.getName()=='SubOrder'){
                for ( Dom.XMLNode clds:child.getChildElements()){
                    if(clds.getName()=='Gift'){
                        for ( Dom.XMLNode cldG:clds.getChildElements())
                            unitandTotal.putall(ItemMapping(cldG));
                    }
                    else
                        unitandTotal.putall(ItemMapping(clds));
                }                    
            }
            
            if(child.getName()=='Total'){  
                unitandTotal.put('quote:'+child.getAttribute( child.getAttributeKeyAt(0), '' ),double.valueOf(child.getText()));          
            }
        }
        System.debug('responsetoQLI======' + unitandTotal);
        
        return unitandTotal;
    }
    public static map<string,double> ItemMapping(Dom.XMLNode clds){
        map<string,double> unitandTotal=new map<string,double>();
        if(clds.getName()=='Item'){
            string sku=clds.getAttribute(clds.getAttributeKeyAt(2),'')+''+integer.valueOf(clds.getAttribute(clds.getAttributeKeyAt(1),''));
            for ( Dom.XMLNode cld:clds.getChildElements()){
                if(cld.getName()=='Charges'){
                    for(Dom.XMLNode c:cld.getChildElements()){
                        if(c.getName()=='Charge'){
                            unitandTotal.put(sku+':'+c.getAttribute(c.getAttributeKeyAt( 0),'')+':'+c.getChildElements()[0].getName(),double.valueOf(c.getChildElements()[0].getText()));
                            
                            if(c.getChildElements()[1].getName()=='LineEffective')
                                unitandTotal.put(sku+':'+c.getAttribute(c.getAttributeKeyAt( 0),'')+':'+c.getChildElements()[1].getName(),double.valueOf(c.getChildElements()[1].getText()));
                            else if(c.getChildElements()[1].getName()=='Discount'){
                                for(Dom.XMLNode xld:c.getChildElements()[1].getChildElements())
                                    unitandTotal.put(sku+':Discount:'+xld.getName(),double.valueOf(xld.getText()));    
                                unitandTotal.put(sku+':'+c.getAttribute(c.getAttributeKeyAt( 0),'')+':'+c.getChildElements()[2].getName(),double.valueOf(c.getChildElements()[2].getText()));
                            }
                        }
                        if(c.getName()=='Tax'){
                            system.debug(c.getChildElements()[0].getText()+'tax======='+c.getAttribute(c.getAttributeKeyAt( 0),''));
                            unitandTotal.put(sku+':Tax:'+c.getAttribute(c.getAttributeKeyAt( 0),'')+':'+c.getChildElements()[0].getName(),double.valueOf(c.getChildElements()[0].getText()));                                    
                        }
                        
                        //system.debug(c.getAttribute(c.getAttributeKeyAt( 0),'')+'===='+c.getChildElements()[0].getName()+'====='+c.getChildElements()[0].getText());                        
                    }
                }                        
            }
            
        }   
        return unitandTotal;
    }
    public static string errorResponse(string xml){
        string errorMsg='';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Dom.XMLNode node = doc.getRootElement();
        List<Dom.XMLNode> children = node.getChildElements();
        for ( Dom.XMLNode child : children ){
            if(child.getName()=='Error')
                for ( Dom.XMLNode clds:child.getChildElements())
                errorMsg=errorMsg+'\n'+clds.getText();
        }
        return errorMsg;
    }
    public static void saveErrorActivity(string quoteid,string msg,string email){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // Set the recipient address
        message.setToAddresses(new String[] {email });
        message.setSubject('Pricing servive failure');
        message.setplainTextBody(msg);
        message.setWhatId(quoteid);
        message.setSaveAsActivity(true);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
    }
}