/**
 * Modelo para el grid del buscador de perfiles de la pestaña de administración.
 */
Ext.define('HreRem.model.Perfil', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name:'pefId'
            },
            {
            	name:'id'
            },
            {
            	name: 'perfilDescripcion'
            },
            {
            	name: 'perfilDescripcionLarga'
            },
            {
            	name:'perfilCodigo'
            },
            {
            	name:'funcionDescripcion'
            },
            {
            	name:'funcionDescripcionLarga'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'perfil/getPerfiles'
		}
    }
});