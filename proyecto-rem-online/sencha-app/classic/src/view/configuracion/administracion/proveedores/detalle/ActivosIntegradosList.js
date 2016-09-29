Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ActivosIntegradosList', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'activosintegradoslist',
	topBar: false,
	idPrincipal : 'id',
	
    bind: {
        store: '{activosIntegrados}'
    },
    
    initComponent: function () {
     	
     	var me = this;
		
	    
		me.columns = [
				{
					xtype: 'actioncolumn',
					handler: 'onActivosVinculadosClick',
					items: [{
				        tooltip: 'Ver Activo',
				        iconCls: 'app-list-ico ico-ver-activov2'
				    }],
				    flex     : 0.15,            
				    align: 'center',
				    menuDisabled: true,
				    hideable: false
				},
		        {
		        	dataIndex: 'numActivo',
		        	text: HreRem.i18n('header.numero.activo.haya'),
		        	flex:0.5
		        },
		        {
			        xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('proveedoresdetalletabpanel').getViewModel().getStore('comboTipoActivo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        flex: 0.6,
			        text: HreRem.i18n('fieldlabel.tipo'),
			        dataIndex: 'tipoCodigo',
			        editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoActivo}'
			            },
			            reference: 'cbAIColTipo'
			        }
		        },
		        {
			        xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('proveedoresdetalletabpanel').getViewModel().getStore('comboSubtipoActivo').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        flex: 0.8,
			        text: HreRem.i18n('fieldlabel.subtipo'),
			        dataIndex: 'subtipoCodigo',
			        editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSubtipoActivo}'
			            },
			            reference: 'cbAIColSubtipo'
			        }
		        },
		        {
			        xtype: 'gridcolumn',
			        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			        	var foundedRecord = this.up('proveedoresdetalletabpanel').getViewModel().getStore('comboCartera').findRecord('codigo', value);
			        	var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        flex: 0.6,
			        text: HreRem.i18n('fieldlabel.cartera'),
			        dataIndex: 'carteraCodigo',
			        editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboCartera}'
			            },
			            reference: 'cbAIColCartera'
			        }
		        },
		        {
		        	
		            dataIndex: 'direccion',
		            text: HreRem.i18n('fieldlabel.direccion'),
		            flex: 0.9,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 250
		            }
		        },
		        {
		            dataIndex: 'participacion',
		            text: HreRem.i18n('header.porcentaje.participacion'),
		            flex: 0.5,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 7
		            }
		        },
		        {
		            dataIndex: 'fechaInclusion',
		            text: HreRem.i18n('header.activos.integrados.fecha.inclusion'),
		            flex: 0.6,
		            formatter: 'date("d/m/Y")',
		            editor: {
		            	xtype: 'datefield'
		            }
		        },
		        {
		            dataIndex: 'fechaExclusion',
		            text: HreRem.i18n('header.activos.integrados.fecha.exclusion'),
		            flex: 0.6,
		            formatter: 'date("d/m/Y")',
		            editor: {
		            	xtype: 'datefield'
		            }
		        },
		        {
		            dataIndex: 'motivoExclusion',
		            text: HreRem.i18n('header.activos.integrados.motivo.exclusion'),
		            flex: 0.8,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 200
		            }
		        }
		        
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{activosIntegrados}'
		            }
		        }
		    ];
		    
		    me.callParent();
   }

});