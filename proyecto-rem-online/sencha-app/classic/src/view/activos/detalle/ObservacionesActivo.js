Ext.define('HreRem.view.activos.detalle.ObservacionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'observacionesactivo',    
	layout: 'fit',
	launch: null,
	listeners: { 	
    	boxready: function (tabPanel) { 
    		tabPanel.evaluarEdicion();
    	},
    	show: function(tab){
    		tab.doLoad(tab);
    	}
    },

    initComponent: function () {
    	
    	//ConfiguraciÛn de la pestaÒa
        var me = this;
        me.reference = "observacionesactivoref_"+me.launch;
        me.store = me.lookupController().getViewModel().getStore("storeObservaciones_"+me.launch)
        me.setTitle(HreRem.i18n('title.observaciones'));
        var items = [
			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal : 'activo.id',
			    topBar: true,
			    disabledDeleteBtn: true,
			    reference: 'listadoObservaciones_'+me.launch,
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeObservaciones_'+me.launch+'}'
				},
				secButtons: {
					secFunPermToEnable : 'ACTIVO_OBSERVACIONES_ADD'
				},
				columns: [
				   {    text: 'Usuario',
			        	dataIndex: 'nombreCompleto',
			        	flex: 1
			       },
				   {
			            text: 'Fecha',
			            dataIndex: 'fecha',
			            flex: 1,
			        	formatter: 'date("d/m/Y")'
			       },
			       {
			    	   xtype: 'gridcolumn',
				        renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
				        	var store =  this.up('activosdetallemain').getViewModel().getStore('storeTipoObservacionActivo');
				        	if(store.isLoading()) {
				        		store.on('load', function(){
				        			var launch = me.up('activosdetallemain').lookupReference('observacionesactivoref').launch;
	            		       		var grid = me.up('activosdetallemain').lookupReference('listadoObservaciones_'+launch).getView();
	            		       		grid.refreshNode(rowIndex);
	            		       	});
				        	}
				            var foundedRecord = store.findRecord('codigo', value);
				            var descripcion;
				        	if(!Ext.isEmpty(foundedRecord)) {
				        		descripcion = foundedRecord.getData().descripcion;
				        	}
				            return descripcion;
				       }, 
			    	   dataIndex: 'tipoObservacionCodigo',
			           text: HreRem.i18n('header.tipo.observacion'),
			           flex: 1,
			           editor: {
			        	   xtype: 'comboboxfieldbase',
			        	   addUxReadOnlyEditFieldPlugin: false,
				           allowBlank: false,
				           bind: {
		        	   			store: '{storeTipoObservacionActivo}'
				           },
				           listeners: {
				           		expand: function( combo ) {
				           			var tab = combo.up("observacionesactivo")
				           			var whiteList = tab.getWhiteList(tab.launch);
				           			if (whiteList.length > 0){
				           				combo.getStore().clearFilter(true);
				           				tab.setStoreWithPermittedValues(combo.getStore(), whiteList);
				           			}
				           		}
				           }
			           }
			       },
			       {   
			       		text: 'Observaci√≥n',
			       	    dataIndex: 'observacion',
			       		flex: 6,
			       		maxLength : 1000,
			       		editor: {
			       			xtype:'textarea',
			       			allowBlank: false
			       		}
			       }
			    ],

			    listeners : {
   	                beforeedit : function(editor, context, eOpts ) {
   	                	var allowEdit = true;		
	   	         	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
	   	         	    	allowEdit = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
	   	         	    			&& $AU.userHasFunction('EDITAR_SITU_POSESORIA_ACTIVO'));
	   	         	    }
   	                    var idUsuario = context.record.get("idUsuario");
   	                	if (!Ext.isEmpty(idUsuario))
   	                	{
	   	                    allowEdit = $AU.sameUserPermToEnable(idUsuario);
	   	                    this.editOnSelect = allowEdit;
	   	                    
   	                	}
   	                	return allowEdit;
	                }
	            },

	            onGridBaseSelectionChange: function (grid, records) {
	            	if(!records.length)
            		{
            			me.down('#removeButton').setDisabled(true);
            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
            			{
            				me.down('#addButton').setDisabled(false);
            			}
            		}
            		else
            		{
            			var idUsuario = records[0].get("idUsuario");
            			var allowRemove = $AU.sameUserPermToEnable(idUsuario);
            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
            			{
            				me.down('#removeButton').setDisabled(!allowRemove);
            			}
            		}
	            },

			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeObservaciones_'+me.launch+'}'
			            }
			        }
			    ]
			}
        ];
        me.items = items;
     	me.doLoad(me);
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    },
    
    doLoad: function( panel ) {
    	var storeObservaciones = panel.buildStoreWithProxy(panel);
		// Extraparams en el store para hacer una carga dinamica dependiendo del tab. Utiliza el model Observaciones.
		storeObservaciones.load({
			callback: function (records, operation, success) {
				// Propagar los extraParams para el resto de acciones.
				this.getModel().getProxy().setExtraParams(this.getProxy().getExtraParams());
			}
		}, true);
    },
  //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar
    evaluarEdicion: function() {    	
		var me = this;

		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false" || me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			me.down('[xtype=gridBaseEditableRow]').setTopBar(false);
		}
    },
    buildStoreWithProxy: function (panel){
    	var viewModel = panel.lookupController("activosdetallemain").getViewModel();
        var extraParams = {
        	id: viewModel.get("activo.id"),
        	tab: panel.launch
        };
		var storeObservaciones = viewModel.getStore("storeObservaciones_"+panel.launch);
		panel.setExtraParamsToTarget(storeObservaciones, extraParams);
		
    	return storeObservaciones;
    },
    setExtraParamsToTarget: function( target, extraParams ) {
    	// Propagacion de extraParams
    	target.getProxy().setExtraParams(extraParams);
    	target.getModel().getProxy().setExtraParams(extraParams);
    },
    getWhiteList: function (tabLaunch) {
    		var whiteList =  [];
   			switch(tabLaunch) {
			case CONST.OBSERVACIONES_TAB_LAUNCH["ACTIVO"]:
   				whiteList.push(
   					CONST.DD_TOB_TIPO_OBSERVACION['STOCK'],
   					CONST.DD_TOB_TIPO_OBSERVACION['POSESION'],
   					CONST.DD_TOB_TIPO_OBSERVACION['INSCRIPCION'],
   					CONST.DD_TOB_TIPO_OBSERVACION['CARGAS'],
   					CONST.DD_TOB_TIPO_OBSERVACION['LLAVES']
   				);
   			break;
   			
   			case CONST.OBSERVACIONES_TAB_LAUNCH["SANEAMIENTO"]: 
   				whiteList.push(CONST.DD_TOB_TIPO_OBSERVACION['SANEAMIENTO'])
   			break;
   			
   			case CONST.OBSERVACIONES_TAB_LAUNCH["REVISION_TITULO"]: 
   				whiteList.push(CONST.DD_TOB_TIPO_OBSERVACION['REVISION_TITULO']) 
		}
		return whiteList;
    },
    setStoreWithPermittedValues: function ( store, list) {
		store.filter({
			fn: function(record) {
					return list.includes(record.data.codigo);
		    },
		    scope: this
		});
    }
});