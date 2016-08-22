/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoCaliente', {
    extend: 'HreRem.model.Base',

    fields: [
        'idActivo', 'numActivo', 'numActivoRem', 'tipoActuacion', 'tarea', 'perfilActual', 'perfilFuturo', 'fechaVencimiento', 'src', 'caption' 
    ]

});