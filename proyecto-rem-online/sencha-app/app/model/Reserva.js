/**
 * This view is used to present the details of a single Reserva.
 */

Ext.define('HreRem.model.Reserva', {
    extend: 'HreRem.model.Base',

    fields: [
    	'idReserva',
    	'numReserva',
    	'tipoArrasCodigo',
    	{
    		name: 'fechaEnvio',
    		type : 'date',
			dateFormat: 'c'
    	},
    	'importe',
    	'estadoReservaDescripcion',
    	{
    		name: 'fechaFirma',
    		type : 'date',
			dateFormat: 'c'
    	},
    	'conImpuesto',
    	{
			name: 'fechaVencimiento',
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
			name: 'diasFirma',
			calculate: function(data) {
				if(Ext.isDefined(data) && data.fechaFirma != null)
					return Math.floor(Ext.Date.getElapsed(data.fechaFirma)/86400000);
				else
					return null;
			},
			depends: 'fechaFirma'
    	},
    	'codigoSucursal',
    	'cartera',
    	'sucursal',
    	'estadoReservaCodigo',
    	'motivoAmpliacionArrasCodigo',
    	'solicitudAmpliacionArras',
    	{
    		name: 'fechaVigenciaArras',
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
    		name: 'fechaAmpliacionArras',
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
    		name: 'fechaPropuestaProrrogaArras',
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
    		name: 'fechaComunicacionCliente',
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
    		name: 'fechaComunicacionClienteRescision',
    		type : 'date',
			dateFormat: 'c'
    	},
    	{
    		name: 'fechaFirmaRescision',
    		type : 'date',
			dateFormat: 'c'
    	},
		{
			name: 'inscripcionTitulo',
			type: 'boolean'
			
		},
		{
			name: 'tanteoDL',
			type: 'boolean'
			
		},
		{
			name: 'selloCalidad',
			type: 'boolean'
			
		},
		{
			name: 'temasTecnicos',
			type: 'boolean'
			
		},
		{
			name: 'posesion',
			type: 'boolean'
			
		},
		{
			name: 'temasCatastrales',
			type: 'boolean'
			
		},
		{
			name: 'autorizacionVpo',
			type: 'boolean'
			
		},
		{
			name: 'fechaContabilizacionArras',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name: 'inscripcionTituloMotivo',
			type: 'boolean'
			
		},
		{
			name: 'tanteoDLMotivo',
			type: 'boolean'
			
		},
		{
			name: 'selloCalidadMotivo',
			type: 'boolean'
			
		},
		{
			name: 'temasTecnicosMotivo',
			type: 'boolean'
			
		},
		{
			name: 'posesionMotivo',
			type: 'boolean'
			
		},
		{
			name: 'temasCatastralesMotivo',
			type: 'boolean'
			
		},
		{
			name: 'autorizacionVpoMotivo',
			type: 'boolean'
			
		}
		
    ],

    proxy: {
		type: 'uxproxy',
		localUrl: 'reserva.json',
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveReserva'
        },
        extraParams: {tab: 'reserva'}
    }
});
          