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
			name:'fechaIngresoDepositoString'
		},
		{
			name: 'estadoCodigo'
		},
		{
			name:'fechaDevolucionDepositoString'
		},
		{
			name: 'ibanDevolucionDeposito'
		},
		{
			name: 'cuentaBancariaVirtual'
		},
		{
			name: 'cuentaBancariaCliente'
		},
		{
			name: 'numOfertaCaixa'
		},
		{
			name: 'checkSubasta',
			type: 'boolean'
		},
		{
			name:'titularesConfirmados'
		},
		{
			name:'importeOferta'
		},
		{
			name:'importeOfertaFormateado',
			convert: function(value, record) {
				//if (Ext.isEmpty(record.get('importeOferta'))) {
					if (record.get('importeOferta') === undefined) {
					return "*****";
				} else {
					return  record.get('importeOferta');
				}
			},
			depends: 'importeOferta'
		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'ofertas/getDetalleOfertaById'
        }
    }
});