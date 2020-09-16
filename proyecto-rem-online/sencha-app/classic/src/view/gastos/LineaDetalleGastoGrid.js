Ext.define('HreRem.view.gastos.LineaDetalleGastoGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'lineaDetalleGastoGrid',
	topBar		: true,
	addButton	: true,
	requires	: ['HreRem.model.LineaDetalleGastoGridModel', 'HreRem.view.gastos.VentanaCrearLineaDetalleGasto'],
	reference	: 'lineaDetalleGastoGrid',
	editOnSelect: false,
	overflowX: 'scroll',
	bind: { 
		store: '{storeLineaGastoDetalle}'
	},
	listeners:{
		rowdblclick: 'abrirVentanaModificarLineaDetalle'
	},
	
    initComponent: function () {


     	var me = this;
     	var cartera  = me.up("gastodetallemain").viewModel.data.gasto.data.cartera != "08";
     	var estadoModificar = me.lookupController().getView().getViewModel().getData().gasto.getData().estadoModificarLineasDetalleGasto;
     	var isRefacturado = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPorOtroGasto;
     	var isRefacturadoPadre = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPadre;

        me.topBar = estadoModificar && !isRefacturado && !isRefacturadoPadre;
     	
     	me.setTitle(HreRem.i18n('title.gasto.detalle.economico.lineas.detalle'));
     	
		me.columns = [
				{ 
		    		dataIndex: 'id',
		    		reference: 'idLineaDetalle',
		    		name: 'idLineaDetalle',
		    		hidden: true
	    		},
	    		  {
		            dataIndex: 'subtipoGasto',
		            reference: 'subtipoGasto',
		            name:'subtipoGasto',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.subtipoGasto'),
		            flex: 0.7 ,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('comboSubtiposGasto').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	}
		        },  {
		            dataIndex: 'baseSujeta',
		            reference: 'baseSujeta',
		            name:'baseSujeta',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.baseSujeta'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'baseNoSujeta',
		            reference: 'baseNoSujeta',
		            name:'baseNoSujeta',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.baseNoSujeta'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'recargo',
		            reference: 'recargo',
		            name:'recargo',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.recargo'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'tipoRecargo',
		            reference: 'tipoRecargo',
		            name:'tipoRecargo',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoRecargo'),
		            flex: 0.7 ,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('comboTipoRecargo').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	}
		        },  {
		            dataIndex: 'interes',
		            reference: 'interes',
		            name:'interes',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.interes'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'costas',
		            reference: 'costas',
		            name:'costas',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.costas'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'otros',
		            reference: 'otros',
		            name:'otros',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.otros'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'provSupl',
		            reference: 'provSupl',
		            name:'provSupl',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.provSupl'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'tipoImpuesto',
		            reference: 'tipoImpuesto',
		            name:'tipoImpuesto',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoImpuesto'),
		            flex: 0.7,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('comboTipoImpuesto').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	}
		        },  {
		            dataIndex: 'operacionExentaImp',
		            reference: 'operacionExentaImp',
		            name:'operacionExentaImp',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.operacionExentaImp'),
		            flex: 0.7,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('comboSiNoGastoBoolean').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	}
		        },  {
		            dataIndex: 'esRenunciaExenta',
		            reference: 'esRenunciaExenta',
		            name:'esRenunciaExenta',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.esRenunciaExenta'),
		            flex: 0.7,
		            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
		            	var foundedRecord = this.lookupController().getViewModel().getStore('comboSiNoGastoBoolean').findRecord('codigo', value);
		            	var descripcion;
		            	
		        		if(!Ext.isEmpty(foundedRecord)) {
		        			descripcion = foundedRecord.getData().descripcion;
		        		}
		            	return descripcion;
		        	}
		        },  {
		            dataIndex: 'tipoImpositivo',
		            reference: 'tipoImpositivo',
		            name:'esTipoImpositivo',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoImpositivo'),
		            flex: 0.7 
		        },  {
		            dataIndex: 'cuota',
		            reference: 'cuota',
		            name:'cuota',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.cuota'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'importeTotal',
		            reference: 'importeTotal',
		            name:'importeTotal',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.importeTotal'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ccBase',
		            reference: 'ccBase',
		            name:'ccBase',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccBase'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ppBase',
		            reference: 'ppBase',
		            name:'ppBase',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppBase'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ccEsp',
		            reference: 'ccEsp',
		            name:'ccEsp',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccEsp'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ppEsp',
		            reference: 'ppEsp',
		            name:'ppEsp',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppEsp'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ccTasas',
		            reference: 'ccTasas',
		            name:'ccTasas',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccTasas'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ppTasas',
		            reference: 'ppTasas',
		            name:'ppTasas',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppTasas'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ccRecargo',
		            reference: 'ccRecargo',
		            name:'ccRecargo',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccRecargo'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ppRecargo',
		            reference: 'ppRecargo',
		            name:'ppRecargo',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppRecargo'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ccInteres',
		            reference: 'ccInteres',
		            name:'ccInteres',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccInteres'),
		            flex: 0.7  		
		        }, {
		            dataIndex: 'ppInteres',
		            reference: 'ppInteres',
		            name:'ppInteres',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppInteres'),
		            flex: 0.7  		
		        },
		        
		        
		        
		        {
		        	dataIndex: 'subcuentaBase',
		            reference: 'subcuentaBase',
		            name:'subcuentaBase',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.subcuentaBase'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'apartadoBase',
		            reference: 'apartadoBase',
		            name:'apartadoBase',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.apartadoBase'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'capituloBase',
		            reference: 'capituloBase',
		            name:'capituloBase',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.capituloBase'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'subcuentaRecargo',
		            reference: 'subcuentaRecargo',
		            name:'subcuentaRecargo',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.subcuentaRecargo'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'apartadoRecargo',
		            reference: 'apartadoRecargo',
		            name:'apartadoRecargo',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.apartadoRecargo'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'capituloRecargo',
		            reference: 'capituloRecargo',
		            name:'capituloRecargo',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.capituloRecargo'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'subcuentaTasa',
		            reference: 'subcuentaTasa',
		            name:'subcuentaTasa',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.subcuentaTasa'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'apartadoTasa',
		            reference: 'apartadoTasa',
		            name:'apartadoTasa',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.apartadoTasa'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'capituloTasa',
		            reference: 'capituloTasa',
		            name:'capituloTasa',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.capituloTasa'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'subcuentaIntereses',
		            reference: 'subcuentaIntereses',
		            name:'subcuentaIntereses',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.subcuentaIntereses'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'apartadoIntereses',
		            reference: 'apartadoIntereses',
		            name:'apartadoIntereses',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.apartadoIntereses'),
		            flex: 0.7  	
		        },
		        {
		        	dataIndex: 'capituloIntereses',
		            reference: 'capituloIntereses',
		            name:'capituloIntereses',
		            hidden: cartera,
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.capituloIntereses'),
		            flex: 0.7  	
		        }
		    ];
			
			me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'lineaDetalleGastoPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            overflowX: 'scroll',
		            bind: {
		            	store: '{storeLineaGastoDetalle}'
		            }
		        }
		    ];

		    me.callParent();
    },
    
 
    onAddClick: function(btn){
    	var me = this;
    	var idGasto = me.lookupController().getView().getViewModel().get("gasto.id")
		var grid = me;
    	var tieneTrabajos = me.lookupController().getView().getViewModel().getData().gasto.getData().tieneTrabajos;
	
    	if(tieneTrabajos){
    		me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.crear.gasto.linea.detalle.con.trabajos")); 
    	}else{
    		Ext.create("HreRem.view.gastos.VentanaCrearLineaDetalleGasto",
				{entidad: 'lineaDetalleGasto', idGasto: idGasto, parent:grid, idLineaDetalleGasto: null, record:null}).show();
    	}

    }, 
    
    onDeleteClick: function(){
    	var me = this;
    	var selection =  me.getSelection();
    	var grid = me;
    	
    	if(selection.length == 0){
    		me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.eliminar.gasto.linea.detalle")); 
    		return;
    	}
    	
    	var idLineaDetalleGasto = me.getSelection()[0].getData().id;
    	Ext.Msg.show({
			   title: HreRem.i18n('title.mensaje.confirmacion'),
			   msg: HreRem.i18n('msg.fieldlabel.eliminar.gasto.linea.detalle'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	grid.mask(HreRem.i18n("msg.mask.loading"));
			        	var url = $AC.getRemoteUrl('gastosproveedor/deleteGastoLineaDetalle');
		    			Ext.Ajax.request({
		    	    		url: url,
		    	    		method : 'GET',
		    	    		params: {
		    	    			idLineaDetalleGasto:idLineaDetalleGasto
		    	    		},
		    	    		
		    	    		success: function(response, opts){
		    	    			grid.getStore().load();
		    	    			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok")); 
		    	    			grid.unmask();
		    	    			grid.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
		    	    			grid.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
		    	    			grid.up('gastodetalle').down('activosafectadosgasto').funcionRecargar();
		    	    			var comboLineas = grid.up('gastodetalle').down('activosafectadosgasto').down('[reference=comboLineasDetalleReference]');
		    	   		        comboLineas.getStore().load();
		    	   		        comboLineas.reset();
		       		         
		    	   		        var gridElementos = grid.up('gastodetalle').down('activosafectadosgasto').down('[reference=listadoActivosAfectadosRef]');
		    	   		        gridElementos.getStore().getProxy().setExtraParams({'idLinea':-1})
		    	   		        gridElementos.getStore().load();
		    	    		},
		    			 	failure: function(record, operation) {
		    			 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    			 		grid.unmask();
		    			    },
		    			    callback: function(record, operation) {
		    			    	grid.unmask();
		    			    }
		    	    	});
			        }
			   }
		});

    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    }
    
});
