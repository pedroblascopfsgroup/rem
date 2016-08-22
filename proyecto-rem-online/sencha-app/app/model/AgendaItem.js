/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.AgendaItem', {
    extend: 'HreRem.model.Base',

    fields: [
        'id','nombreTarea','descripcion', 'entidadInformacion', 'fechaVenc', 'fechaVencReal', 'diasVencidoSQL', 'volumenRiesgoVencido'   
    ]

});