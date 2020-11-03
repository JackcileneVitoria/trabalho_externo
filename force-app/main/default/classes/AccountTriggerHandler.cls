public class AccountTriggerHandler {
    public static void onAfterInsert(List<Account> contaLista) {
        AccountDomain.verificaTipoRegistroConta(contaLista);
    }

    public static void onAfterUpdate(List<Account> contaLista, Map<Id, Account> mapaValoresAntigos) {
        AccountDomain.validaNumeroCliente(contaLista, mapaValoresAntigos);
    }
}
