public class AccountSelector {
    public static List<Task> retornaTarefasPorSetIdContas(Set<Id> idsContas){
        return [SELECT Id FROM Task WHERE CreatedDate < LAST_N_DAYS:90 AND WhatId IN: idsContas];
    }

    public static List<Opportunity> retornaOppPorSetIdContas(Set<Id> idsContas){
        return [SELECT 
                    Id, 
                    AccountId 
                FROM 
                    Opportunity 
                WHERE 
                    AccountId IN: idsContas 
                AND 
                    CloseDate < LAST_N_DAYS:120 
                AND 
                    StageName != 'Negotiation/Review'];
    }

    public static List<Account> retornaContasPorSetId(Set<Id> idsContas){
        return [SELECT Id, Inativa__c FROM Account WHERE Id IN: idsContas];
    }
}
