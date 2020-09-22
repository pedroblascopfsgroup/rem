Ext.define('HreRem.view.activos.detalle.AnyadirGastoAsociadoAdquisicion', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirgastoasociadoadquisicion',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
    controller: 'activodetalle',
    reference: 'AnyadirGastoAsociadoAdquisicionRef',
    viewModel: {
        type: 'activodetalle'
    },
    
    idActivo: null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		},
		boxready: function(window) {
			var me = this;
			//me.initWindow();
		}
		
	},
	
	/*initWindow: function() {
    	var me = this;
    	
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
			);
    	}
    	
    },*/

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n("title.gastos.asociados.adquisicion"));
    	
    	me.buttons = [ { itemId: 'btnAnyadir', text: HreRem.i18n('itemSelector.btn.add.tooltip'), handler: 'onClickBotonAnyadirGastoAsociadoAdquisicion'}, 
    		{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarVentanaGastoAsociado'}];
    	
    	me.items = [
				{
					xtype: 'formBase', 
					collapsed: false,
					layout: {
						type: 'vbox'
    				},
   			 		cls:'formbase_no_shadow',
   			 		defaults: {
   			 			width: '100%',
   			 			msgTarget: 'side',
   			 			addUxReadOnlyEditFieldPlugin: false
   			 		},			
					
					items: [
					
						{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('header.gastos.asociados.adquisicion.tipo.gasto'),
				        	reference: 'comboTipoGastoAsociadoRef',
				        	name: 'comboTipoGastoAsociado',
			            	bind: {
								store: '{storeTipoGastoAsociado}'
			            	},
			            	width: '100%',
							publishes: 'value',		
							displayField	: 'descripcion',
							valueField		: 'codigo',
    						allowBlank: false
			    		},
			    		{ 
							xtype: 'datefieldbase',
							reference: 'fechaSolicitudRef',
							formatter: 'date("d/m/Y")',
				        	fieldLabel:  HreRem.i18n('header.gastos.asociados.adquisicion.fecha.solicitud'),	
				        	width: '100%',
				        	name: 'fechasolicitud',
				        	allowBlank: false
			    		},
			    		{
		                	xtype: 'datefieldbase',
		                	reference: 'fechaPagoRef',
							formatter: 'date("d/m/Y")',
				        	fieldLabel:  HreRem.i18n('header.gastos.asociados.adquisicion.fecha.pago'),	
				        	width: '100%',
				        	name: 'fechapago',
				        	allowBlank: false
	            		},
	            		{
		                	xtype: 'numberfieldbase',
							reference: 'importeRef',
				        	fieldLabel:  HreRem.i18n('header.gastos.asociados.adquisicion.importe'),	
				        	width: '100%',
				        	name: 'importe',
				        	allowBlank: false
	            		}/*,
	            		{
	            			
	            			fieldLabel:  HreRem.i18n('header.gastos.asociados.adquisicion.factura'),
 							xtype: 'filefield',
							name: 'factura',
							reference: 'facturaRef',
							msgTarget: 'side',
							width: '100%',
							buttonConfig: {
								iconCls: 'ico-search-white',
								text: ''
							},
							align: 'right',
							listeners: {
					            change: function(fld, value) {
					                        	
					                   var lastIndex = null,
					                   fileName = null;
					                   if(!Ext.isEmpty(value)) {
						                     lastIndex = value.lastIndexOf('\\');
											 if (lastIndex == -1) return;
											 fileName = value.substring(lastIndex + 1);
						                     fld.setRawValue(fileName);
					                   }
					             }
				           }
	            		}*/,
	            		{
		                	xtype: 'textareafieldbase',
		                	reference: 'observacionesRef',
		                	fieldLabel: HreRem.i18n('header.gastos.asociados.adquisicion.Obsercaciones'),		
		                	name: 'observaciones',
		                	width: '100%'
	            		}
		    	  	]
		}];
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('activo', me.idActivo);
    }
});
    
    