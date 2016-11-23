Ext.define('HreRem.view.activos.detalle.LlavesList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'llaveslist',
    reference	: 'llaveslistref',
	topBar		: true,
	idPrincipal : 'activo.id',
	
    bind: {
        store: '{storeLlaves}'
    },
    
    listeners: { 	
    	boxready:'quitarEdicionEnGridEditablePorFueraPerimetro'
    },
    
    initComponent: function () {
     	
     	var me = this;
     	
    	me.listeners = {	    	
 			rowclick: 'onLlavesListClick',
 			deselect: 'onLlavesListDeselected',
 			rowdblclick: 'valdacionesEdicionLlavesList',
 			beforeedit: 'valdacionesEdicionLlavesList'
 	    };

		me.columns = [
		      /*  {
		        	dataIndex: 'idActivo',
		        	text: HreRem.i18n('header.publicacion.activos.vinculados.idActivo'),
		        	flex:0.8,
		        	hidden:true
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.idLlave'),
		        	dataIndex: 'id',
		        	flex:0.6,
		        	hidden:true
		        },*/

		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.numLlave'),
		        	dataIndex: 'numLlave',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20
		            }
		        },
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.codigoCentroLlaves'),
		        	dataIndex: 'codCentroLlave',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20
		            }
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
			            reference: 'cbColCompleto',
			            listeners: {
							change: 'valdacionesEdicionLlavesList'
						},
		            	allowBlank: false
			        }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.motivoIncompleto'),
		        	dataIndex: 'motivoIncompleto',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	reference: 'motivoIncompletoRef',
		            	maxLength: 100,
		            	disabled: true,
		            	allowBlank: true
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