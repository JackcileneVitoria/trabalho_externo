import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Import Labels
import InformacoesAtualizadasSucesso from '@salesforce/label/c.InformacoesAtualizadasSucesso';
export default class EditarConta extends LightningElement {
    @api recordId;

    label = {
        InformacoesAtualizadasSucesso
    };

    handleError(event) {
        this.exibirAlerta('error', 'Erro', event.detail.detail);
    }

    handleSuccess(event) {
        this.exibirAlerta('success', 'Sucesso', this.label.InformacoesAtualizadasSucesso);
    }

    // Alertas
    exibirAlerta(tipo, titulo, mensagem) {
        this.dispatchEvent(new ShowToastEvent({ 
            title: titulo, 
            message: mensagem, 
            variant: tipo }));
    }

}