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
		//store: '{storeAgendaRevisionTitulo}'
	},
	
    initComponent: function () {


     	var me = this;
        //me.topBar = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']));
        //me.editOnSelect = ($AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']));

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
		            flex: 0.7  		
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
		            flex: 0.7  		
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
		            flex: 0.7  		
		        },  {
		            dataIndex: 'operacionExenta',
		            reference: 'operacionExenta',
		            name:'operacionExenta',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.operacionExenta'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'renunciaExenta',
		            reference: 'renunciaExenta',
		            name:'renunciaExenta',
		            text: HreRem.i18n('fieldlabel.gasto.linea.detalle.renunciaExenta'),
		            flex: 0.7  		
		        },  {
		            dataIndex: 'tipoImpositivo',
		            reference: 'tipoImpositivo',
		            name:'tipoImpositivo',
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
		                //store: '{storeCalifiacionNegativa}'
		            }
		        }
		    ];

		    me.callParent();
    },
    
 
    onAddClick: function(btn){
    	var me = this;
    	var idGasto = me.lookupController().getView().getViewModel().get("gasto.id")
		var grid = me;
		var idLineaDetalleGasto = null;
	
		Ext.create("HreRem.view.gastos.VentanaCrearLineaDetalleGasto",
				{entidad: 'lineaDetalleGasto', idEntidad: idGasto, idLineaDetalleGasto: idLineaDetalleGasto, parent:grid}).show();

    }, 
    
    onDeleteClick: function(){
    	var me = this;
    	var selection =  me.getSelection();
    	var grid = me;
    	
    	if(selection.length == 0){
    		me.fireEvent("errorToast", HreRem.i18n("msg.agenda.revision.titulo.eliminar.no.seleccionado")); 
    		return;
    	}
    	
    	var idLineaDetalleGasto = me.getSelection()[0].getData().id;
    	Ext.Msg.show({
			   title: HreRem.i18n('title.mensaje.confirmacion'),
			   msg: HreRem.i18n('msg.agenda.revision.titulo.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	grid.mask(HreRem.i18n("msg.mask.loading"));
			        	var url = $AC.getRemoteUrl('admision/deleteAgendaRevisionTitulo');
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
