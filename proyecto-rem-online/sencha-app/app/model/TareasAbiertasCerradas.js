/**
 * This view is used to present the details of a single TareasAbiertasCerradas.
 */
Ext.define('HreRem.model.TareasAbiertasCerradas', {
    extend: 'HreRem.model.Base',

    fields: [
             'dia', 
             'mes', 
             'gestor',
             'abiertas', 
             'cerradas'
    ]
    
});