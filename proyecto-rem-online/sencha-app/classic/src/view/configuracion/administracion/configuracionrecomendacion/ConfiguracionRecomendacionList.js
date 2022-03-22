Ext.define('HreRem.view.configuracion.administracion.configuracionrecomendacion.ConfiguracionRecomendacionList', {
    extend			: 'HreRem.view.common.GridBaseEditableRow',
    xtype			: 'configuracionrecomendacionlist',
	idPrincipal 	: 'configrecomendacion.id',
	editOnSelect	: true,
	topBar          : true,
    bind			: {
        store: '{configuracionrecomendacion}'
    },
    recordName		: 'testigo',
	recordClass 	: 'HreRem.model.ConfigRecomendacion',
	requires	: [ 'HreRem.view.configuracion.ConfiguracionModel'],
	loadAfterBind	: false,
    initComponent: function () {
     	var me = this;
		
		me.columns = [
		        {
		            dataIndex: 'id',
		            flex: 0.3,
		            hidden: true
		        },
			    {
			    	dataIndex: 'cartera',
			    	text: HreRem.i18n('header.configuracion.recomendacion.cartera'),
		            flex: 2,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboCartera}'
			            },
						allowBlank: false,
			            reference: 'colCarteraRec',
			            chainedStore: '{comboSubcarteraFiltered}',
						chainedReference: 'colSubcarteraRec',
			            listeners: {
			            	select: 'onChangeCarteraRecomendacionChainedCombo'
			            }
			        }
		        },
		        {
		            dataIndex: 'subcartera',
		            text: HreRem.i18n('header.configuracion.recomendacion.subcartera'),
		            flex: 2,
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSubcarteraFiltered}'
			            },
						allowBlank: false,
			            reference: 'colSubcarteraRec'
			        }
		        },
		        {
		            dataIndex: 'tipoComercializacion',
		            text: HreRem.i18n('header.configuracion.recomendacion.tipo.venta'),		   				        	
		        	flex: 2, 
		            editor: {
	        			xtype: 'combobox',
	        			bind: {
		            		store: '{comboTiposComercializacion}'
		            	},
						allowBlank: false,					            	
		            	displayField: 'descripcion',
						valueField: 'codigo'
		        	}		            
		        },
		        {
		            dataIndex: 'equipoGestion',
		            text: HreRem.i18n('header.configuracion.recomendacion.equipo.gestion'),		   				        	
		        	flex: 2, 
		            editor: {
	        			xtype: 'combobox',
	        			bind: {
		            		store: '{comboEquipoGestion}'
		            	},	
						allowBlank: false,				            	
		            	displayField: 'descripcion',
						valueField: 'codigo'
		        	}		            
		        },
		        {
		            dataIndex: 'porcentajeDescuento',
		            text: HreRem.i18n('header.configuracion.recomendacion.porcentaje.descuento'),
		            flex: 1,
		            editor: {
		        		xtype:'numberfield',
						minValue: 0,
						maxValue: 100
		        	},
		        	renderer: function(value) {
		            	return Ext.util.Format.number(value, '0.00%');
		            }
		        },
		        {
		            dataIndex: 'importeMinimo',
		            text: HreRem.i18n('header.configuracion.recomendacion.importe.minimo'),
		            flex: 1,
		            editor: {
		        		xtype:'numberfield',
						minValue: 0
		        	},
		        	renderer: function(value) {
		        		if (value != null && value != undefined) return Ext.util.Format.currency(value);
		        	}
		        },
		        {
			        dataIndex: 'recomendacionRCDC',
			        text: HreRem.i18n('header.configuracion.recomendacion'),		   				        	
		        	flex: 1, 
		            editor: {
	        			xtype: 'combobox',
	        			bind: {
		            		store: '{comboRecomendacionRCDC}'
		            	},					            	
		            	displayField: 'descripcion',
						valueField: 'codigo'
		        	}	        
		        }
		
		    ];

		    me.dockedItems = [{
			    xtype: 'toolbar',
			    dock: 'bottom',
			    items: [
			        { iconCls:'x-tbar-loading', itemId:'reloadButton', handler: 'reloadInfo'}
			    ]
			}];

		    me.callParent();
   }
});