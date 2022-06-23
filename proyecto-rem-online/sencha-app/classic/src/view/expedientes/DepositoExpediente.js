Ext.define('HreRem.view.expedientes.DepositoExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'depositoexpediente',    
    disableValidation: false,
    saveMultiple: true,
    refreshAfterSave: true,
    reference: 'depositoExpediente',
    scrollable	: 'y',
	records: ['expediente','deposito'],	
	recordsClass: ['HreRem.model.ExpedienteComercial','HreRem.model.Deposito'],    
    requires: ['HreRem.model.ExpedienteComercial','HreRem.model.Deposito'],

    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {
        var me = this;
		me.setTitle(HreRem.i18n('title.deposito'));
		var dataExpediente = me.lookupController().getView().getViewModel().getData().expediente.getData();
		var esBk = dataExpediente.esBankia;
		var botonesEdicion = me.up().down("[itemId=botoneditar]");
		
        var items= [

        	{
                xtype: 'fieldsettable',
                title: HreRem.i18n('fieldlabel.deposito.reserva'), 
                bind: {
                	/*hidden: '{!esBankia}'*/
                },
                colspan: 3,
                items: [
            		{
						xtype: "numberfieldbase",
						reference: 'importeIngresoDeposito',
						fieldLabel: HreRem.i18n('header.importe'),
						bind: {
							readOnly : !$AU.userIsRol("HAYASUPER"),
							value: '{deposito.importeDeposito}'
						}
	    			},
	    			{
						xtype: "datefieldbase",
						reference: 'fechaIngresoDeposito',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.ingreso'),
						bind: {
							value: '{deposito.fechaIngresoDeposito}',
							readOnly: true
						}
	    			},
	    			{
	    				xtype : 'comboboxfieldbase',
						fieldLabel : HreRem.i18n('fieldlabel.estado'),
						reference: 'estadoDeposito',
						bind : {
							store : '{comboEstadoDeposito}',
							value : '{deposito.estadoCodigo}',
							readOnly: true
						}
	    			},
	    			{
						xtype: "datefieldbase",
						reference: 'fechaDevolucionDeposito',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('header.situacion.posesoria.llaves.fechaDevolucion'),
						bind: {
							value: '{deposito.fechaDevolucionDeposito}',
							readOnly: true
						}
	    			},
	    			{
						xtype: "textfieldbase",
						fieldLabel: HreRem.i18n('fieldlabel.deposito.iban.devolucion'),
						bind: {
							value: '{deposito.ibanDevolucionDeposito}'
						},
			    		listeners:{
							'focusLeave': 'checkIbanDevolucion'
			    		}
	    			}/*,
	    			{
	    				text :  HreRem.i18n('fieldlabel.modificar.deposito'),
	                	xtype: 'button',
	                	reference: 'modificarDeposito',
	                	handler: 'onClickModificarDeposito',
	                	margin: '0 0 6 -5',
	                	bind: {
	                		disabled: '{!detalleOfertaModel.id}'
	                	}
	                }*/
	    			
	    		]
			}
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);  	
		
    }
});