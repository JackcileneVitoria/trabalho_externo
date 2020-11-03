@isTest(SeeAllData = false)
public class AccountDomainTest {
    @testSetup static void setup(){
        Id idContaConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        Id idContaParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();

        Account contaConsumidor = new Account();
        contaConsumidor.RecordTypeId = idContaConsumidorFinal;
        contaConsumidor.Name = 'Consumidor Final';
        contaConsumidor.AccountNumber = '496.041.780-32';
        contaConsumidor.Type = 'CPF';
        insert contaConsumidor;

        Account contaParceiro = new Account();
        contaParceiro.RecordTypeId = idContaParceiro;
        contaParceiro.Name = 'Conta Parceiro';
        contaParceiro.AccountNumber = '44.221.208/0001-06';
        contaParceiro.Type = 'CNPJ';
        insert contaParceiro;
    }

    @isTest 
    public static void validaNumeroClienteTest1(){
        Account conta = [SELECT Id, AccountNumber FROM Account WHERE Name = 'Consumidor Final'];
        
        Map<Id, Account> mapaValoresAntigos = new Map<Id, Account>();
        mapaValoresAntigos.putAll(new List<Account>{conta});

        Test.startTest();
            conta.AccountNumber = '367.187.220-90';
            update conta;

            AccountDomain.validaNumeroCliente(new List<Account>{conta}, mapaValoresAntigos);
        Test.stopTest();
    }

    @isTest 
    public static void validaNumeroClienteTest2(){
        Account conta = [SELECT Id, AccountNumber FROM Account WHERE Name = 'Conta Parceiro'];
        
        Map<Id, Account> mapaValoresAntigos = new Map<Id, Account>();
        mapaValoresAntigos.putAll(new List<Account>{conta});

        Test.startTest();
            conta.AccountNumber = '33.770.787/0001-20';
            update conta;
            
            AccountDomain.validaNumeroCliente(new List<Account>{conta}, mapaValoresAntigos);
        Test.stopTest();
    }

    @isTest 
    public static void validaNumeroClienteErro1(){
        Account conta = [SELECT Id, AccountNumber FROM Account WHERE Name = 'Conta Parceiro'];

        Test.startTest();
            try {
                conta.AccountNumber = '00000000000';
                update conta;    
            } catch (Exception ex) {
                System.assert(ex.getMessage().contains('Número do cliente inválido'));
            }
        Test.stopTest();
    }

    @isTest 
    public static void validaNumeroClienteErro2(){
        Account conta = [SELECT Id, AccountNumber FROM Account WHERE Name = 'Consumidor Final'];

        Test.startTest();
            try {
                conta.AccountNumber = '00000000000';
                update conta;    
            } catch (Exception ex) {
                System.assert(ex.getMessage().contains('Número do cliente inválido'));
            }
        Test.stopTest();
    }

    @isTest 
    public static void batchAccountTest(){
        Id idContaConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ConsumidorFinal').getRecordTypeId();
        Id idContaParceiro = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parceiro').getRecordTypeId();
        List<Account> contaLista = new List<Account>();

        for(Integer i = 0; i < 50; i++){
            Account contaConsumidor = new Account();
            contaConsumidor.RecordTypeId = idContaConsumidorFinal;
            contaConsumidor.Name = 'Consumidor Final';
            contaConsumidor.AccountNumber = '496.041.780-32';
            contaConsumidor.Type = 'CPF';
            contaLista.add(contaConsumidor);
        }

        for(Integer i = 0; i < 50; i++){
            Account contaParceiro = new Account();
            contaParceiro.RecordTypeId = idContaParceiro;
            contaParceiro.Name = 'Conta Parceiro';
            contaParceiro.AccountNumber = '44.221.208/0001-06';
            contaParceiro.Type = 'CNPJ';
            contaLista.add(contaParceiro);
        }

        insert contaLista;

        Test.startTest();
            BatchAccountUpdate batchAcc = new BatchAccountUpdate();
            database.executeBatch(batchAcc, 200);
        Test.stopTest();
    }

    @isTest 
    public static void schedulableAccountTest(){
        Test.starttest();
            SchedulableAccountUpdate classeAgendada = new SchedulableAccountUpdate ();   
            String chron = '0 0 /6 * * ?';        
            System.schedule('Teste inativação', chron, classeAgendada);
        Test.stopTest();
    }
}
