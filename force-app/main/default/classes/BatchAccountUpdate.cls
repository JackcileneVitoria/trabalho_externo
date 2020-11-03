global class BatchAccountUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id FROM Account WHERE Inativa__c = false';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Set<Id> idsContas = new Set<Id>();
        for (Account conta : scope) {
            idsContas.add(conta.Id);
        }

        Set<Id> idsContasInativar = new Set<Id>();

        // Busca as tarefas que não possuem data de criação nos últimos 90 dias
        List<Task> tarefasLista = [SELECT Id FROM Task WHERE CreatedDate != LAST_N_DAYS:90 AND WhatId IN: scope];
        for (Task tarefa : tarefasLista) {
            idsContasInativar.add(tarefa.WhatId);
        }

        // Busca as oportunidades que possuem data de fechamento fora dos últimos 120 dias 
        // e com fase diferente de Negociação
        List<Opportunity> oportunidadesLista = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN: idsContas AND CloseDate != LAST_N_DAYS:120 AND StageName != 'Negotiation/Review'];
        for (Opportunity oportunidade : oportunidadesLista) {
            idsContasInativar.add(oportunidade.AccountId);
        }

        List<Account> contasParaAtualizar = new List<Account>();
        List<Account> armazenaContasAtualizar = [SELECT Id, Inativa__c FROM Account WHERE Id IN: idsContasInativar];
        for (Account conta : armazenaContasAtualizar) {
            conta.Inativa__c = true;
            contasParaAtualizar.add(conta);
        }

        if (!contasParaAtualizar.isEmpty()) {
            UPDATE contasParaAtualizar;
        }
    }  

    global void finish(Database.BatchableContext BC){}
}
