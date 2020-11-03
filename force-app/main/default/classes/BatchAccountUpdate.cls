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

        // Busca as tarefas que não possuem data de criação nos últimos 90 dias
        List<Task> tarefasLista = AccountSelector.retornaTarefasPorSetIdContas(idsContas);
        for (Task tarefa : tarefasLista) {
            idsContas.remove(tarefa.WhatId);
        }

        // Busca as oportunidades que possuem data de fechamento fora dos últimos 120 dias 
        // e com fase diferente de Negociação
        List<Opportunity> oportunidadesLista = AccountSelector.retornaOppPorSetIdContas(idsContas);
        for (Opportunity oportunidade : oportunidadesLista) {
            idsContas.remove(oportunidade.AccountId);
        }

        List<Account> contasParaAtualizar = new List<Account>();
        List<Account> armazenaContasAtualizar = AccountSelector.retornaContasPorSetId(idsContas);
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
