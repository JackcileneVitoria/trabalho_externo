trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    if (trigger.isBefore) {
        if (trigger.isInsert) {
            // AccountTriggerHandler.onBeforeInsert(trigger.new);
        } else if (trigger.isUpdate) {
            // AccountTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
        } 
        // else if (trigger.isDelete) {
        //     AccountTriggerHandler.onBeforeDelete(trigger.old, trigger.oldMap);
        // }
    } else if (trigger.isAfter) {
        if (trigger.isInsert) {
            AccountTriggerHandler.onAfterInsert(trigger.new);
        } else if (trigger.isUpdate) {
            AccountTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }
        // else if (trigger.isDelete) {
        //     AccountTriggerHandler.onAfterDelete(trigger.old, trigger.oldMap);
        // }
    }
}