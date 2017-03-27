Ext.define('HreRem.view.activos.detalle.MovimientosLlaveList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'movimientosllavelist',
    reference	: 'movimientosllavelistref',
	topBar		: true,
    bind: {
        store: '{storeMovimientosLlave}'
    },
    
    listeners: { 	
    	edit: 'onClickEditRowMovimientosLlaveList',
		boxready:'quitarEdicionEnGridEditablePorFueraPerimetro',
		beforeedit: 'comprobarFechasMinimasMovimientosLlaveList'
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
		            	reference: 'datefieldEntrega',
		            	maxValue: $AC.getCurrentDate(),
		            	allowBlank: false,
		            	listeners: { 
		            		change: 'onChangeFechasMinimaMovimientosLlaveList'
		            	}
		            }
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fechaDevolucion'),
		            dataIndex: 'fechaDevolucion',
		            formatter: 'date("d/m/Y")',
		        	flex: 1,
	            	editor: {
		            	xtype: 'datefield',
		            	reference: 'datefieldDevolucion',
		            	maxValue: $AC.getCurrentDate()
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
	    
   },
   
   onAddClick: function (btn) {
	   
	   var me = this;
	   var puedeAgregarMovimiento = !me.existenLlavesSinDevolver(me.getStore().getData().items);
	   
	   if(puedeAgregarMovimiento) {
		   var rec = Ext.create(me.getStore().config.model);
		   me.getStore().sorters.clear();
		   me.editPosition = 0;
	       me.getStore().insert(me.editPosition, rec);
	       me.rowEditing.isNew = true;
	       me.rowEditing.startEdit(me.editPosition, 0);
	       me.disableAddButton(true);
	       me.disablePagingToolBar(true);
	       me.disableRemoveButton(true);
	   }
	   else {
		   me.fireEvent("errorToast", HreRem.i18n("msg.error.agregar.movimiento.llave.sin.devolver"));
	   }
   },
   
   //Comprueba si hay alguno movimiento sin fecha devolucion
   existenLlavesSinDevolver: function(movimientos) {
	   var existen = false;
	   
	   for(var i=0; i< movimientos.length; i++) {
		   var mov = movimientos[i].data;
		   if(Ext.isEmpty(mov.fechaDevolucion)) {
			   existen = true;
			   break;
		   }
	   }
	   
	   return existen;
   }
});