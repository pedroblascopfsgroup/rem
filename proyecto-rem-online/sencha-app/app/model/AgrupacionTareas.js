/**
 * This view is used to present the details of a single TareasAbiertasCerradas.
 */
Ext.define('HreRem.model.AgrupacionTareas', {
    extend: 'HreRem.model.Base',

    fields: [
         'idGestor', 
         'gestor', 
         'categoria', 
         'estado', 
         'cantidad', 
         'porcentaje'
    ]
    
});