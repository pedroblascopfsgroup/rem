/**
 *  Modelo para el detalle de una oferta del activo. 
 */
Ext.define('HreRem.model.DetalleOfertaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
 		{
			name:'usuAlta'
		},
		{
			name:'usuBaja'
		},
 		{
			name:'numOferta'
		},
		{
			name:'intencionFinanciar'
		},
		{
			name:'numVisitaRem'
		},
		{
			name:'procedenciaVisita'
		},
		{
			name:'motivoRechazoDesc'
		},
		{
			name:'sucursal'
		},
		{
			name:'ofertaExpress'
		},
		{
			name:'necesitaFinanciacion'
		},
		{
			name:'observaciones'
		},
		{
			name:'fechaEntradaCRMSF',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name: 'empleadoCaixa',
			type: 'boolean'
		},
		{
			name:'importeDeposito'
		},
		{
			name:'fechaIngresoDeposito',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name: 'estadoCodigo'
		},
		{
			name:'fechaDevolucionDeposito',
			type:'date',
    		dateFormat: 'c'
		},
		{
			name: 'ibanDevolucionDeposito'
		},
		{
			name: 'cuentaBancariaVirtual'
		},
		{
			name: 'cuentaBancariaCliente'
		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'ofertas/getDetalleOfertaById'
        }
    }
});