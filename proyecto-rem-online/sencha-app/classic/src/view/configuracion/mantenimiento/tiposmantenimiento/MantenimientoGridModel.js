Ext.define('HreRem.model.MantenimientoGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',	  
    fields: [
            {
            	name: 'id'
            },
            {
            	name: 'codCartera'
            },
            {
            	name: 'codSubCartera'
            },
            {
            	name: 'codPropietario'
            },
            {
            	name: 'carteraMacc'
            },
            {
            	name: 'fechaCrear'
            },
            {
            	name: 'usuarioCrear'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            //read: 'proveedores/getMediadoresEvaluar',
            //update: 'proveedores/updateMediadoresEvaluar'
		}
    }
});