public class AccountDomain {
    public static void validaNumeroCliente(List<Account> contaLista, Map<Id, Account> mapaValoresAntigos){ 
        Id idContaConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();

        for (Account conta : contaLista) {
            if (conta.AccountNumber != mapaValoresAntigos.get(conta.Id).AccountNumber) {
                if (conta.RecordTypeId == idContaConsumidorFinal) {
                    Boolean cpfValido = ValidateUtil.isCPF(conta.AccountNumber.replace('.','').replace('-',''));
                    if (!cpfValido) {
                        conta.addError('Número do cliente inválido');
                    }
                }else {
                    Boolean cnpjValido = ValidateUtil.isCNPJ(conta.AccountNumber.replace('.','').replace('/','').replace('-',''));
                    if (!cnpjValido) {
                        conta.addError('Número do cliente inválido');
                    }
                }
            }
        }
    }

    public static void verificaTipoRegistroConta(List<Account> contaLista){

        List<Opportunity> oportunidadeLista = new List<Opportunity>(); 
        List<Task> tarefaLista = new List<Task>();

        Id idContaConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        Id idContaParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();

        for (Account conta : contaLista) {
            if (conta.RecordTypeId == idContaParceiro) {
                Opportunity oportunidade = new Opportunity();
                oportunidade.Name = conta.Name + ' - Oportunidade Parceiro';
                oportunidade.CloseDate = Date.today().addDays(30);
                oportunidade.StageName = 'Qualification';
                oportunidade.AccountId = conta.Id;
                oportunidadeLista.add(oportunidade);
            }else if (conta.RecordTypeId == idContaConsumidorFinal) {
                Task tarefa = new Task();
                tarefa.Subject = 'Consumidor Final';
                tarefa.WhatId = conta.Id;
                tarefa.Status = 'Not Started';
                tarefa.Priority = 'Normal';
                tarefaLista.add(tarefa);
            }
        }

        if (!tarefaLista.isEmpty()) {
            insert tarefaLista;
        }

        if (!oportunidadeLista.isEmpty()) {
            insert oportunidadeLista;
        }
    }
}
