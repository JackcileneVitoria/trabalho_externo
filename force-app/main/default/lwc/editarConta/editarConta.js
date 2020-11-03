import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const campos = ['Account.invalidField' ];
export default class EditarConta extends LightningElement {
    @api recordId;
    handleError(event) {
        this.exibirAlerta('error', 'Erro', event.detail.detail);
    }

    handleSuccess(event) {
        this.exibirAlerta('success', 'Sucesso', 'Informações atualizadas com sucesso!');
    }

    // Alertas
    exibirAlerta(tipo, titulo, mensagem) {
        this.dispatchEvent(new ShowToastEvent({ 
            title: titulo, 
            message: mensagem, 
            variant: tipo }));
    }

}