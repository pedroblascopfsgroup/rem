Ext.define('HreRem.view.activos.comercial.ofertas.datosGenerales.EditarDeposito', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'editarDepositoWindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 5,    
    height	: Ext.Element.getViewportHeight() > 380 ? 380 : Ext.Element.getViewportHeight() - 50 ,

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    modoEdicion: true,
    
    deposito: null,
    parent:null,
    cuentaBancariaVirtual:null,
    cuentaBancariaCliente:null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		}
		
	},
	
    initComponent: function() {
    	
    	var me = this;
    	me.setTitle(HreRem.i18n('fieldlabel.modificar.deposito'));
    	
    	if(me.deposito == undefined){
    		me.deposito=[];
    	}
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Guardar', handler: 'onClickSaveModificarDeposito'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickCancelarModificarDeposito'}];

    	me.items = [
				{
					xtype: 'formBase', 
					collapsed: false,    				
					border: false,
					items: [
						{
							xtype: "numberfield",
							reference: 'importeDeposito',
							fieldLabel: HreRem.i18n('header.importe'),
							margin: '10 10 10 10',
							width: '80%',
							allowBlank: false,
							bind: {
								value: me.deposito.importeDeposito
							}
		    			},
		    			{
							xtype: "datefield",
							reference: 'fechaIngresoDeposito',
							formatter: 'date("d/m/Y")',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.ingreso'),
							margin: '10 10 10 10',
							width: '80%',
							allowBlank: false,
							bind: {
								value: me.deposito.fechaIngresoDeposito
							}
		    			},
		    			{
		    				xtype : 'combobox',
							fieldLabel : HreRem.i18n('fieldlabel.estado'),
							reference: 'estadoCodigo',
							margin: '10 10 10 10',
							width: '80%',
							displayField: 'descripcion',
							valueField: 'codigo',
							allowBlank: false,
							bind : {
								store : '{comboEstadoDeposito}',
								value : me.deposito.estadoCodigo
							},
							listeners: {
								select: 'onSelectEstadoDeposito'
							}
		    			},
		    			{
							xtype: "datefield",
							reference: 'fechaDevolucionDeposito',
							fieldLabel: HreRem.i18n('header.situacion.posesoria.llaves.fechaDevolucion'),
							margin: '10 10 10 10',
							width: '80%',
							bind: {
								value: me.deposito.fechaDevolucionDeposito
							}
		    			},
		    			{
							xtype: "textfield",
							fieldLabel: HreRem.i18n('fieldlabel.deposito.iban.devolucion'),
							reference:'ibanDevolucionDeposito',
							formatter: 'date("d/m/Y")',
							margin: '10 10 10 10',
							width: '80%',
							bind: {
								value: me.deposito.ibanDevolucionDeposito
							}
		    			},
						{
							xtype: "textfield",
							reference: 'cuentaBancariaVirtual',
							fieldLabel: HreRem.i18n('fieldlabel.cuenta.virtual'),
							margin: '10 10 10 10',
							width: '80%',
							allowBlank: false,
							minLength: 20,
							maxLength: 20,
							minLengthText: 'Debe tener 20 digitos',
							bind: {
								value: me.cuentaBancariaVirtual
							}
		    			},
						{
							xtype: "textfield",
							reference: 'cuentaBancariaCliente',
							fieldLabel: HreRem.i18n('fieldlabel.cuenta.cliente'),
							margin: '10 10 10 10',
							width: '80%',
							allowBlank: false,
							minLength: 20,
							maxLength: 20,
							minLengthText: 'Debe tener 20 digitos',
							bind: {
								value: me.cuentaBancariaCliente
							}
		    			}
					]
				}
		    ];
    	
    	me.callParent();

    	if(!Ext.isEmpty(me.deposito)){
    		var comboEstadoDeposito = me.down('[reference="estadoCodigo"]');
    		comboEstadoDeposito.getStore().load();
    		comboEstadoDeposito.setValue(me.deposito.estadoCodigo);
    	}
    	
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('activo', me.activo);
    }
});
    