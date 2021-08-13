/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoPropietario', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    

    		{
    			name:'id'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'porcPropiedad'
    		},
    		{
    			name:'tipoGradoPropiedadDescripcion'
    		},
    		{
    			name:'tipoPersonaDescripcion'
    		},    		
    		{
    			name:'localidadDescripcion'
    		},
    		{
    			name:'provinciaDescripcion'
    		},
    		{
    			name:'localidadContactoDescripcion'
    		},
    		{
    			name:'provinciaContactoDescripcion'
    		},
    		{
    			name:'codigo'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'apellido1'
    		},
    		{
    			name:'apellido2'
    		},
    		{
    			name:'tipoDocIdentificativoDesc'
    		},
    		{
    			name:'docIdentificativo'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		},
    		{
    			name:'codigoPostal'
    		},
    		{
    			name:'nombreContacto'
    		},
    		{
    			name:'telefono1Contacto'
    		},
    		{
    			name:'telefono2Contacto'
    		},
    		{
    			name:'emailContacto'
    		},
    		{
    			name:'direccionContacto'
    		},
    		{
    			name:'codigoPostalContacto'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'tipoPropietario'
    		},
    		{
    			name: 'isPrincipal',
    			calculate: function(data) { 
    				return data.tipoPropietario == "Principal";
    			},
    			depends: 'tipoPropietario'
    		},
    		{
    			name: 'anyoConcesion'
    		},
    		{
    			name: 'fechaFinConcesion',
    			type : 'date',
    			dateFormat : 'c'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getListPropietarioById',
		api: {
            read: 'activo/getListPropietarioById',
            create: 'activo/saveActivoPropietarioTab',
            update: 'activo/updateActivoPropietarioTab',
            destroy: 'activo/getListPropietarioById'

        }
    }
    
    

});