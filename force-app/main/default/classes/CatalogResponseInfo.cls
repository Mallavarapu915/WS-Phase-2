public class CatalogResponseInfo {
    
    public cls_sku sku;
    public class cls_sku {
        
        public String catalogSku;   //22-7773633
        public String name; //Shun Classic Chef's Knife, 8&quot;
        public cls_img img;
        public String available;    //true
        public String sellable; //true
        public String sellableIfNla;    //true
        public String displayable;  //true
        public String backorder;    //false
        public cls_price price;
        public String alertMessage; //Please note that we cannot accept cancellations or returns on monogrammed or personalized&#160; items. Please allow extra processing time for all made-to-order items.
        public cls_merch merch;
        public List<String> promotionConstraints;//MAP, EFP and may have more values in future
        public String inHome;   //false
        public String directShip;   //false
        public String taxCategory;  //1
        public String freeShip; //true
        public String freePz;   //false
        public String furniture;    //false
        public String priceModifier;    //Regular
        public String giftWrap; //true
        public String monogram; //true
        public String personalize;  //false
        public String sku;  //7773633
        public String catalog;  //22
        public String catalogGeneration;    //320030325.0
        public String schemaLocation;   //null
        
    }
    public class cls_img {
        public String rel;  //sku
        public String href; //https://www.williams-sonoma.com/wsimgs/ab/images/dp/wcm/201938/1018/img52m.jpg
        public String size; //m
        public String alt;  //Shun Classic Chef's Knife, 8
        public String height;   //400
        public String width;    //400
    }
    public class cls_price {
        public String selling;  //149.95
        public String regular;  //188.00
        public String surcharge;
        public String retail;   //149.95
        public String typeName; //special
    }
    public class cls_merch {
        public String itemType; //REG
        public String dept; //105
        public String className;    //11
        public String subClass; //1
    }
    public static CatalogResponseInfo parse(String json){
        json=json.replace('""', '"');
        json=json.replace('"\\', '"');
        json=json.replace('class', 'className');
        json=json.replace('type', 'typeName');
        json=json.replace('id', 'sku');
        return (CatalogResponseInfo) System.JSON.deserialize(json, CatalogResponseInfo.class);
    }
}