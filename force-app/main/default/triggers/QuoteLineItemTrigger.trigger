trigger QuoteLineItemTrigger on QuoteLineItem (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    QuoteLineItemTriggerHandler handler = new QuoteLineItemTriggerHandler();
    handler.execute();
    
    
      if (Trigger.isAfter) {
        if (Trigger.isInsert) {

    Set<id> qliIdSet = new Set<id>();
    for(QuoteLineItem qliIDs :trigger.new){
        qliIdSet.add(qliIDs.id);
    }
    if(!test.isrunningtest())
    database.executeBatch(new CatalogServiceGetCallout(qliIdSet));
}
} 

}