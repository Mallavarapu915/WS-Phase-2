@isTest
global class CatalogServiceHttpMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {

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
        xml+='<inHome>false</inHome>';
        xml+='<directShip>false</directShip>';
        xml+='<taxCategory>1</taxCategory>';
        xml+='<PromotionConstraint>MAP</PromotionConstraint>';  
        xml+='<PromotionConstraint>ExcludePrice</PromotionConstraint>';
        xml+='<freeShip>false</freeShip>';
        xml+='<freePz>false</freePz>';
        xml+='<furniture>false</furniture>';
        xml+='<priceModifier>Clearance</priceModifier>';
        xml+='<giftWrap>true</giftWrap>';
        xml+='<monogram>true</monogram>';
        xml+='<personalize>true</personalize>';
        xml+='</sku>';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/xml');
        response.setBody(xml);
        response.setStatusCode(200);
        return response;
    }
}