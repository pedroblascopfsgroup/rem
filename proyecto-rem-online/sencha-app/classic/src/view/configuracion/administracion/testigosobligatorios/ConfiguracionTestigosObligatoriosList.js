Ext.define('HreRem.view.configuracion.administracion.testigosobligatorios.ConfiguracionTestigosObligatoriosList', {
    extend			: 'HreRem.view.common.GridBaseEditableRow',
    xtype			: 'configuraciontestigosobligatorioslist',
	idPrincipal 	: 'testigo.id',
	editOnSelect	: true,
	topBar          : true,
    bind			: {
        store: '{configuraciontestigosobligatorios}'
    },
    recordName		: 'testigo',
	recordClass 	: 'HreRem.model.Testigo',
	loadAfterBind	: false,
    initComponent: function () {
     	var me = this;

		me.columns = [
		        {
		            dataIndex: 'id',
		            text: HreRem.i18n('header.configuracion.testigos.obligatorios.id'),
		            flex: 0.3,
		            hidden: true
		        },
			    {
			    	dataIndex: 'cartera',
			    	text: HreRem.i18n('header.configuracion.testigos.obligatorios.cartera'),
		            flex: 2,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboCartera}'
			            },
			            reference: 'cbColCartera',
			            chainedStore: '{comboSubcarteraFiltered}',
						chainedReference: 'cbColSubcartera',
			            listeners: {
			            	select: 'onChangeCarteraTestigosChainedCombo'
			            }
			        }
		        },
		        {
		            dataIndex: 'subcartera',
		            text: HreRem.i18n('header.configuracion.testigos.obligatorios.subcartera'),
		            flex: 2,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSubcarteraFiltered}',
							disabled: '{!cbColCartera.selection}'
			            },
			            reference: 'cbColSubcartera'
			        }
		        },
		        {
		            dataIndex: 'tipoComercializacion',
		            text: HreRem.i18n('header.configuracion.testigos.obligatorios.tipo.venta'),		   				        	
		        	flex: 2, 
		            editor: {
	        			xtype: 'combobox',
	        			bind: {
		            		store: '{comboTiposComercializacion}'
		            	},					            	
		            	displayField: 'descripcion',
						valueField: 'codigo'
		        	}		            
		        },
		        {
		            dataIndex: 'equipoGestion',
		            text: HreRem.i18n('header.configuracion.testigos.obligatorios.equipo.gestion'),		   				        	
		        	flex: 2, 
		            editor: {
	        			xtype: 'combobox',
	        			bind: {
		            		store: '{comboEquipoGestion}'
		            	},					            	
		            	displayField: 'descripcion',
						valueField: 'codigo'
		        	}		            
		        },
		        {
		            dataIndex: 'porcentajeDescuento',
		            text: HreRem.i18n('header.configuracion.testigos.obligatorios.porcentaje.descuento'),
		            flex: 1,
		            editor: {
		        		xtype:'numberfield'
		        	},
		        	renderer: function(value) {
		            	return Ext.util.Format.number(value, '0.00%');
		            }
		        },
		        {
		            dataIndex: 'importeMinimo',
		            text: HreRem.i18n('header.configuracion.testigos.obligatorios.importe.minimo'),
		            flex: 1,
		            editor: {
		        		xtype:'numberfield'
		        	},
		        	renderer: function(value) {
		        		return Ext.util.Format.currency(value);
		        	}
		        },
		        {
			        dataIndex: 'requiereTestigos',
			        text: HreRem.i18n('header.configuracion.testigos.obligatorios.requiere.testigos'),		   				        	
		        	flex: 1, 
		            editor: {
	        			xtype: 'combobox',
	        			bind: {
		            		store: '{comboSinSino}'
		            	},					            	
		            	displayField: 'descripcion',
						valueField: 'codigo'
		        	}	        
		        }
		
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{configuraciontestigosobligatorios}'
		            }
		        }
		    ];

		    me.callParent();
   },
    
    onAddClick: function(btn){
		
		var me = this;
		var rec = Ext.create(me.getStore().config.model);
		me.getStore().sorters.clear();
		me.editPosition = 0;
		rec.setId(null);
		rec.data.esEditable = true;
	    me.getStore().insert(me.editPosition, rec);
	    me.rowEditing.isNew = true;
	    me.rowEditing.startEdit(me.editPosition, 0);
	    me.disableAddButton(true);
	    me.disablePagingToolBar(true);

   }
});