global class SchedulableAccountUpdate implements Schedulable {
    global void execute(SchedulableContext sc){
        BatchAccountUpdate batch = new BatchAccountUpdate();
        database.executebatch(batch ,200);
    }
}

/** EXECUTAR **/
// SchedulableAccountUpdate job = new SchedulableAccountUpdate();
// String sch = '0 0 */6 ? * MON-FRI';
// System.schedule('Inativar Contas', sch , job);
