public class AccountSelector {
    public static List<Task> retornaTarefasPorSetIdContas(Set<Id> idsContas){
        Date ultimos90Dias = Date.today().addDays(-90);

        return [SELECT 
                    Id,
                    WhatId 
                FROM 
                    Task 
                WHERE 
                    CreatedDate >: ultimos90Dias 
                AND 
                    CreatedDate <= TODAY
                AND 
                    WhatId IN: idsContas];
    }

    public static List<Opportunity> retornaOppPorSetIdContas(Set<Id> idsContas){
        Date ultimos120Dias = Date.today().addDays(-120);

        return [SELECT 
                    Id, 
                    AccountId 
                FROM 
                    Opportunity 
                WHERE 
                    AccountId IN: idsContas 
                AND 
                    CloseDate >: ultimos120Dias
                AND
                    (CloseDate <= TODAY OR CloseDate > TODAY) 
                AND 
                    StageName != 'Negotiation/Review'];
    }

    public static List<Account> retornaContasPorSetId(Set<Id> idsContas){
        return [SELECT Id, Inativa__c FROM Account WHERE Id IN: idsContas];
    }
}
