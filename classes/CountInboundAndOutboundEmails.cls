public without Sharing class CountInboundAndOutboundEmails {

	public static void countOutboundEmails(List<EmailMessage> list_emailMessages){
        DateTime completionDate = System.now();
        Map<Id, EmailMessage> emIds = new Map<Id, EmailMessage>();
        List<Case> casetoUpdate = new List<Case>();
        for (EmailMessage em : list_emailMessages){
            if(em.Incoming == false){
                emIds.put(em.ParentId, em);
            }
        }
        if(emIds.size()>0){
            List<Case> caseList = [Select id,count_of_outbound_emails__c,Status 
                                   from Case Where Id IN : emIds.keySet()];
            if(caseList.size()>0){
                Set<Id> updateCases = new Set<Id>();
                for(Case c : caseList){
                    if(c.count_of_outbound_emails__c == NULL){
                        c.count_of_outbound_emails__c = 0;
                    }
					c.count_of_outbound_emails__c++;
                    casetoUpdate.add(c);
                }
                if(casetoUpdate.size()>0){
                    update casetoUpdate;
                
            }
        }
    }
    
    public static void countInboundEmails(List<EmailMessage> list_emailMessages){
        Map<Id, EmailMessage> emIds = new Map<Id, EmailMessage>();
        List<Case> casetoUpdate = new List<Case>();
        for (EmailMessage em : list_emailMessages){
            if(em.Incoming){
                emIds.put(em.ParentId, em);
            }
        }
        if(emIds.size()>0){
            List<Case> caseList = [Select id,Count_of_Inbound_Emails__c,Status from Case Where Id IN : emIds.keySet() AND Status != 'Closed' AND Status !='New'];
            if(caseList.size()>0){
                for(Case c : caseList){
                    if(c.Count_of_Inbound_Emails__c == NULL){
                        c.Count_of_Inbound_Emails__c = 0;
                    }
					c.Count_of_Inbound_Emails__c++;
                    casetoUpdate.add(c);
                }
                if(casetoUpdate.size()>0){
                    update casetoUpdate;
                }
            }
        }
    }
}