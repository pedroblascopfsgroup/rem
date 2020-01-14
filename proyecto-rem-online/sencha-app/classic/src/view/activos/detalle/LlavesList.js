Ext.define('HreRem.view.activos.detalle.LlavesList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'llaveslist',
    reference	: 'llaveslistref',
	allowDeselect: false,
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
 			canceledit: 'onLlavesListClick',
 			rowdblclick: 'valdacionesEdicionLlavesList',
 			beforeedit: 'valdacionesEdicionLlavesList'
 	    };

		me.columns = [
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.numLlave'),
		        	dataIndex: 'numLlave',
		        	flex: 1
		        },
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.tipoTenedor'),
		        	dataIndex: 'tipoTenedor',
		        	flex: 1,
		            editor: {
		            	xtype: 'textfield',
		            	maxLength: 20
		            }
		        },
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.nombreTenedor'),
		        	dataIndex: 'nombreTenedor',
		        	flex: 1
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.telefono.tenedor'),
		        	dataIndex: 'telefonoTenedor',
		        	flex: 0.7
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fecha.anillado'),
		        	dataIndex: 'fechaPrimerAnillado',
		        	formatter: 'date("d/m/Y")',
		        	flex: 0.7
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fecha.recepcion'),
		        	dataIndex: 'fechaRecepcion',
		        	formatter: 'date("d/m/Y")',
		        	flex: 0.7
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
			        }
		        },	
		        {   
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.observaciones'),
		        	dataIndex: 'observaciones',
		        	flex: 1
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
		    
		    
		    me.saveSuccessFn = function() {
		    	var me = this;
		    	me.up('situacionposesoriaactivo').funcionRecargar();
		    	return true;
		    },
		    
		    me.deleteSuccessFn = function() {
		    	var me = this;
		    	me.up('situacionposesoriaactivo').funcionRecargar();
		    	return true;
		    }

		    me.callParent();
   }
});