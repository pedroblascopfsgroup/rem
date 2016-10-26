Ext.define('HreRem.view.activos.detalle.LlavesList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'llaveslist',
    reference	: 'llaveslistref',
	topBar		: true,
	idPrincipal : 'activo.id',
	
    bind: {
        store: '{storeLlaves}'
    },
    
    initComponent: function () {
     	
     	var me = this;

		me.columns = [
		        {
		        	dataIndex: 'idActivo',
		        	text: HreRem.i18n('header.publicacion.activos.vinculados.idActivo'),
		        	flex:0.8,
		        	hidden:true
		        },
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.idMovimiento'),
		        	dataIndex: 'idMovimiento',
		        	flex:0.9
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.idLlave'),
		        	dataIndex: 'idLlave',
		        	flex:0.6
		        },
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.centroLlaves'),
		        	dataIndex: 'nomCentroLlave',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 100
		            }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.archivo1'),
		        	dataIndex: 'archivo1',
		        	flex: 0.7,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 50
		            }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.archivo2'),
		        	dataIndex: 'archivo2',
		        	flex: 0.7,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 50
		            }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.archivo3'),
		        	dataIndex: 'archivo3',
		        	flex: 0.7,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 50
		            }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.completo'),
		        	dataIndex: 'juegoCompleto',
		        	flex: 0.7,
		        	renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboSiNoRem').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboSiNoRem}'
			            },
			            reference: 'cbColCompleto'
			        }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.motivoIncompleto'),
		        	dataIndex: 'motivoIncompleto',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 100
		            }
		        },
				{
		            text: HreRem.i18n('header.situacion.posesoria.llaves.tipoTenedor'),
		            dataIndex: 'codigoTipoTenedor',
		        	flex: 1,
		        	renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
			            var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboTipoTenedor').findRecord('codigo', value);
			            var descripcion;
			        	if(!Ext.isEmpty(foundedRecord)) {
			        		descripcion = foundedRecord.getData().descripcion;
			        	}
			            return descripcion;
			        },
			        editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoTenedor}'
			            },
			            reference: 'cbColTipoTenedor'
			        }
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.nombreTenedor'),
		            dataIndex: 'nomTenedor',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 100
		            }
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fechaEntrega'),
		            dataIndex: 'fechaEntrega',
		            formatter: 'date("d/m/Y")',
		        	flex: 1,
	            	editor: {
		            	xtype: 'datefield'
		            }
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fechaDevolucion'),
		            dataIndex: 'fechaDevolucion',
		            formatter: 'date("d/m/Y")',
		        	flex: 1,
	            	editor: {
		            	xtype: 'datefield'
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
		                store: '{storeLlaves}'
		            }
		        }
		    ];

		    me.callParent();
   }
});