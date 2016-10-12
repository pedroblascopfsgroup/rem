Ext.define('HreRem.view.administracion.gastos.GestionGastosList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'gestiongastoslist',
    requires: ['HreRem.view.administracion.gastos.AnyadirNuevoGasto'],
	topBar: true,
	removeButton: false,
	bind: {
       	store: '{gastosAdministracion}'
    },
    listeners:{
       rowdblclick: 'onClickAbrirGastoProveedor'
    },
    
    initComponent: function() {
    	
    	var me = this;
    	
    	me.columns = [
	 							{   
						        	dataIndex: 'id',
						        	flex: 1,
						        	hidden: true,
						        	hideable: false
						       	},
						       	{   
						       		text: HreRem.i18n('header.num.gasto'),
						        	dataIndex: 'numGastoHaya',
						        	flex: 1
						       	},
	    	                     {
									text: HreRem.i18n('header.num.factura.liquidacion'),
									dataIndex: 'numFactura',
									flex: 1
							   },
	    	                     
	    	                     {
	    	                    	 text: HreRem.i18n('header.tipo.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'tipoDescripcion'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.subtipo.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'subtipoDescripcion'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.concepto.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'concepto'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.proveedor.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'codigoProveedor'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.emision.gasto'),
	    	                     	flex: 1,
	    	                    	dataIndex: 'fechaEmision',
		   	                    	formatter: 'date("d/m/Y")'	
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.importe.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'importeTotal'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.tope.pago.gasto'),
	    	                     	flex: 1,
	    	                    	dataIndex: 'fechaTopePago',
	    	                    	formatter: 'date("d/m/Y")'	
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.pago.gasto'),
	    	                     	flex: 1,
	    	                    	dataIndex: 'fechaPago',
	    	                    	formatter: 'date("d/m/Y")'	
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.periodicidad.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'periodicidadDescripcion'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.destinatario.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'destinatarioDescripcion'
	    	                     }
		];
		
		me.dockedItems= [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            displayInfo: true,
		            bind: {
		                store: '{gastosAdministracion}'
		            }
		        }
		];
    	
    	me.callParent();
    },
    
    onClickAdd: function (btn) {
		var me = this,
		parent= me.up('gestiongastos');
		Ext.create('HreRem.view.administracion.gastos.AnyadirNuevoGasto',{parent: parent}).show();				    				    	
	},
	
	onClickRemove: function (btn) {
		var me  = this;
		
		Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			            var sm = me.getSelectionModel();
			            sm.getSelection()[0].erase();
			       }
			   }
		});
		
		
	}
   
    	        
				

    
});