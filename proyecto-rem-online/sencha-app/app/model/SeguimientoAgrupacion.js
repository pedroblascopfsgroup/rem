/**
 *  Modelo para el tab Seguimiento de Agrupaciones 
 */
Ext.define('HreRem.model.SeguimientoAgrupacion', {
    extend: 'HreRem.model.Base',

    fields: [],
    
	proxy: {
		type: 'uxproxy',
		localUrl: '',
		remoteUrl: '',
		api: {
            create: '',
            update: '',
            destroy: ''
        }
    }

});