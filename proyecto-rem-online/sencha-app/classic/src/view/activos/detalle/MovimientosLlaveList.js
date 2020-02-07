Ext.define('HreRem.view.activos.detalle.MovimientosLlaveList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'movimientosllavelist',
    reference	: 'movimientosllavelistref',
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
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.tipo.poseedor'),
		            dataIndex: 'descripcionTipoTenedorPoseedor',
		        	flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.nombre.poseedor'),
		            dataIndex: 'nombrePoseedor',
		        	flex: 1
		        },
		        		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.tipo.pedidor'),
		            dataIndex: 'descripcionTipoTenedorPedidor',
		        	flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.nombre.pedidor'),
		            dataIndex: 'nombrePedidor',
		        	flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.forma.envio'),
		            dataIndex: 'envio',
		        	flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fecha.envio'),
		            dataIndex: 'fechaEnvio',
		        	flex: 1,
		        	formatter: 'date("d/m/Y")'
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.fecha.recepcion'),
		            dataIndex: 'fechaRecepcion',
		        	flex: 1,
		        	formatter: 'date("d/m/Y")'
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.observaciones'),
		            dataIndex: 'observaciones',
		        	flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.situacion.posesoria.llaves.estado'),
		            dataIndex: 'estadoDescripcion',
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