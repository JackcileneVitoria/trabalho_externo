public class AccountDomain {

    /** Método verifica se o tipo da conta é CPF ou CNPJ e realizada a validação do número informado **/
    public static void validaNumeroCliente(List<Account> contaLista, Map<Id, Account> mapaValoresAntigos){ 
        for (Account conta : contaLista) {
            if (conta.AccountNumber != mapaValoresAntigos.get(conta.Id).AccountNumber) {
                if (conta.Type == 'CPF') {
                    Boolean cpfValido = ValidateUtil.isCPF(conta.AccountNumber.replace('.','').replace('-',''));
                    if (!cpfValido) {
                        conta.addError(label.NumeroClienteInvalido);
                    }
                }else if(conta.Type == 'CNPJ'){
                    Boolean cnpjValido = ValidateUtil.isCNPJ(conta.AccountNumber.replace('.','').replace('/','').replace('-',''));
                    if (!cnpjValido) {
                        conta.addError(label.NumeroClienteInvalido);
                    }
                }
            }
        }
    }

    /** Método verifica tipo de registro da conta e cria uma oportunidade ou tarefa **/
    public static void verificaTipoRegistroConta(List<Account> contaLista){

        List<Opportunity> oportunidadeLista = new List<Opportunity>(); 
        List<Task> tarefaLista = new List<Task>();

        Id idContaConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        Id idContaParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();

        for (Account conta : contaLista) {
            // Caso a conta seja Parceiro, sistema cria uma oportunidade
            if (conta.RecordTypeId == idContaParceiro) {
                Opportunity oportunidade = new Opportunity();
                oportunidade.Name = conta.Name + ' - Oportunidade Parceiro';
                oportunidade.CloseDate = Date.today().addDays(30);
                oportunidade.StageName = 'Qualification';
                oportunidade.AccountId = conta.Id;
                oportunidadeLista.add(oportunidade);

            // Caso a conta seja Consumidor final, sistema cria uma tarefa 
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
