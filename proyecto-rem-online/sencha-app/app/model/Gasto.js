/**
 *  Modelo para el tab Informacion Administrativa de Activos
 */
Ext.define('HreRem.model.Gasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name: 'numGastoHaya'
    	},
    	{
    		name: 'numFactura'
    	},
    	{
    		name: 'tipo'
    	},
    	{
    		name: 'subtipo'

    	},
		{
			name : 'concepto'
		},
		{
			name : 'proveedor'
		},
		{
			name : 'fechaEmision',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'importe'
		},
		{
			name : 'fechaTopePago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'fechaPago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'periodicidad'
		},
		{
			name : 'destinatario'
		},
		{
			name: 'estadoGastoDescripcion'
		},
		{
			name: 'estadoGastoCodigo'
		},
		{
			name: 'importeTotalAgrupacion'
		},
		{
			name: 'existeDocumento',
			type: 'boolean',
			convert: function(v) {
				return v === "true";
			}
		},
    {
			name: 'alertas',
			type: 'boolean',
			convert: function(v) {
				return v === "true";
			}
		},
		{
			name: 'esGastoAgrupado',
			type: 'boolean',
			convert: function(v) {
				return v === "true";
			}
		},
		{
			name: 'sujetoImpuestoIndirecto',
			type: 'boolean',
			convert: function(v) {
				if(v === "true") {
					return 'Si';
				} else {
					return 'No';
				}
			}
		},
		{
			name: 'nombreGestoria'
		},
		{
			name: 'entidadPropietariaDescripcion'
		},
		{
			name: 'destinatarioDescripcion'
		},
		{
			name: 'nombrePropietario'
		},
		{
			name: 'docIdentifPropietario'
		},
		{
			name: 'destinatarioNombreDoc',
			calculate: function(data) {
				var docPropietario = Ext.isDefined(data.docIdentifPropietario) ? data.docIdentifPropietario : '';
				var nomPropietario = Ext.isDefined(data.nombrePropietario) ? data.nombrePropietario : '';
				var docName = docPropietario + ' - ' + nomPropietario;
				return docName;
			},
			depends: 'docIdentifPropietario'
		},
		{
			name: 'gastoRefacturable',
			type:'boolean'
		},
		{
			name: 'gastosRefacturadosGasto'
		},
		{
			name: 'numTrabajo'
		},
		{
			name: 'solicitudPagoUrgente'
		}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'gasto.json',
		api: {
            update: 'gastosproveedor/saveGastosProveedor',
			create: 'gastosproveedor/createGastosProveedor',
			destroy: 'gastosproveedor/deleteGastosProveedor'
        }
    }

});
