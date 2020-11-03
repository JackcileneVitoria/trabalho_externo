global class SchedulableAccountUpdate implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchAccountUpdate batch = new BatchAccountUpdate();
        database.executebatch(batch, 100);
    }
}

/** EXECUTAR DE 6 EM 6 HORAS (4 VEZES AO DIA) DE SEGUNDA A SEXTA **/
// SchedulableAccountUpdate job = new SchedulableAccountUpdate();
// String sch = '0 0 */6 ? * MON-FRI';
// System.schedule('Inativar Contas', sch , job);
