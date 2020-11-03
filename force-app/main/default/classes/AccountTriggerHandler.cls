public class AccountTriggerHandler {
    // public static void onBeforeInsert(List<Account> contaLista) {
            /*
            call before insert actions
            */
    // }

    // public static void onBeforeUpdate(List<Account> contaLista, Map<Id, Account> mapaValoresAntigos) {
            /*
            call before update actions
            */
    // }

    public static void onAfterInsert(List<Account> contaLista) {
        AccountDomain.verificaTipoRegistroConta(contaLista);
    }

    public static void onAfterUpdate(List<Account> contaLista, Map<Id, Account> mapaValoresAntigos) {
        AccountDomain.validaNumeroCliente(contaLista, mapaValoresAntigos);
    }

    // public static void onAfterDelete(List<Account> contaLista, Map<Id, Account> mapaValoresAntigos) {
            /*
            call after delete actions
            */
    // }
}
