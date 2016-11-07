Ext.define('HreRem.view.activos.detalle.MovimientosLlaveList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'movimientosllavelist',
    reference	: 'movimientosllavelistref',
	topBar		: true,
	loadAfterBind: false,
    bind: {
        store: '{storeMovimientosLlave}'
    },
    
    listeners: { 	
    	boxready: function (tabPanel) { 
    		tabPanel.disableAddButton(true);
    	},

    	edit: 'onClickEditRowMovimientosLlaveList',
    	
		boxready:'quitarEdicionEnGridEditablePorFueraPerimetro'
    },
    
    initComponent: function () {
     	
     	var me = this;

		me.columns = [
		        /*{   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.idMovimiento'),
		        	dataIndex: 'id',
		        	flex:0.9,
		        	hidden:true
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.idLlave'),
		        	dataIndex: 'idLlave',
		        	flex:0.6,
		        	hidden: true
		        },*/
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.numLlave'),
		        	dataIndex: 'numLlave',
		        	flex:0.6
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
			            reference: 'cbColTipoTenedor',
		            	allowBlank: false
			        }
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.codTenedor'),
		            dataIndex: 'codTenedor',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 50
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
		            	xtype: 'datefield',
		            	allowBlank: false
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
		                store: '{storeMovimientosLlave}'
		            }
		        }
		    ];

		    me.callParent();
   }
});