var rowCounter = 0;
var sumaValores = function(record, field) {
    var total = 0;
    var j = 0,
    lenn = record.length;
    for (; j < lenn; ++j) {
       total = total + parseFloat(record[j].get(field));
    }
    return total;
};

Ext.define('HreRem.view.gastos.ActivosAfectadosGastoList', {
	extend : 'HreRem.view.common.GridBaseEditableRow',
	xtype : 'activosafectadosgastolist',
	requires: ['HreRem.view.gastos.AnyadirNuevoGastoActivo', 'HreRem.model.LineaDetalleGastoGridModel'],
	cls : 'panel-base shadow-panel',
	idPrincipal : 'id',
	bind : {
		store : '{storeElementosAfectados}'
	},
	listeners : {
		
		beforeedit : function(editor, e) {
			var me = this;
			var record = e.record;
			var columnas = me.getColumns();
			var referenciaCatastral, tipoElementoCodigo, participacion;
			for (var i = 0; i < columnas.length; i++) {
				if (columnas[i].dataIndex == 'referenciaCatastral') {
					referenciaCatastral = columnas[i];
				}
				if (columnas[i].dataIndex == 'participacion') {
					participacion = columnas[i];
				}
			}

			var estadoParaGuardar = me.lookupController().getView().getViewModel().getData().gasto.getData().estadoModificarLineasDetalleGasto;
	    	var isGastoRefacturado = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPorOtroGasto;
	    	var isGastoRefacturadoPadre = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPadre;
	    	var edicion = true;
	    	
	    	if(/*me.up('gastodetallemain').getViewModel().get('gasto.asignadoATrabajos') || */me.up('gastodetallemain').getViewModel().get('gasto.autorizado')){
	    		edicion = false;
	    	}
	    	
			var columnaReferenciaCatastral = referenciaCatastral.getEditor();
			var columnaParticipacion = participacion.getEditor();
			if( edicion && estadoParaGuardar && !isGastoRefacturado && !isGastoRefacturadoPadre){
				if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO'] === record.getData().tipoElementoCodigo){
					columnaReferenciaCatastral.setDisabled(false);
				}else{
					columnaReferenciaCatastral.setDisabled(true);
				}
				columnaParticipacion.setDisabled(false);
			}else{;
				columnaReferenciaCatastral.setDisabled(true);
				columnaParticipacion.setDisabled(true);
			}
		},
		
		boxready: function() {
			var me = this;
			me.evaluarEdicion();
		}
	},
	
	initComponent : function() {
		
		var me = this;
		var cartera = me.lookupController().getView().getViewModel().getData().gasto.getData().cartera
		const esBBVA = CONST.CARTERA['BBVA'] === cartera;
		
		me.tbar =  {
			xtype: 'toolbar',
			dock: 'top',
			items: [
					{itemId: 'addButton', iconCls:'x-fa fa-plus', handler: 'onAddClick', bind: {hidden: '{ocultarBotonesActivos}'}, scope: this},
					{itemId: 'removeButton', iconCls:'x-fa fa-minus', handler: 'onDeleteClick', bind: {hidden: '{ocultarBotonesActivos}'}, disabled: true, scope: this},
					{itemId: 'downloadButton', iconCls:'x-fa fa-download', handler: 'onExportClickActivos'}
			]
		};			
					
		me.features = [{
            id: 'summary',
            ftype: 'summary',
            hideGroupedHeader: true,
            enableGroupingMenu: false,
            dock: 'bottom'
		}];
		me.columns = [
							
				{
					dataIndex : 'id',
					flex : 1,
					hidden : true,
					hideable : false
				},
				{
					text: HreRem.i18n('header.elementos.afectados.id.linea.id'),
					dataIndex : 'idLinea',
					flex : 1,
					hidden : false,
					hideable : false
				},
				{
					dataIndex : 'idActivo',
					flex : 1,
					hidden : true,
					hideable : false
				},
				{
					dataIndex : 'idElemento',
					flex : 1,
					hidden : true
				},
				{
					dataIndex : 'tipoElementoCodigo',
					flex : 1,
					hidden : true
				},
				{
					text : HreRem.i18n('header.elementos.afectados.id.linea'),
					dataIndex : 'descripcionLinea',
					flex : 1,
					hidden : false,
					hideable : false
				},
				{
					text : HreRem.i18n('header.elementos.afectados.tipo.elemento'),
					dataIndex : 'tipoElemento',
					flex : 1,
					hidden : false
				},
				{
					text : HreRem.i18n('header.elementos.afectados.id.elemento'),
					xtype: 'actioncolumn',
		        	dataIndex: 'idElemento',
			        items: [{
			            getClass: function(v, metadata, record ) {
			            	if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO'] === record.getData().tipoElementoCodigo){
			            		return "app-list-ico ico-ver-activov2";
			            	}
			            				            	
			            },
			            handler: 'onEnlaceActivosElementosAfectados'
			        }],
			        renderer: function(value, metadata, record) {        	
			        	return '<div style="float:right; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        },
		            flex     : 1,            
		            align: 'left',
		            hideable: false,
		            sortable: true
				},{
					text : HreRem.i18n('header.activos.afectados.subtipo.activo'),
					dataIndex : 'tipoActivo',
					flex : 1
				}, 
				{
					text : HreRem.i18n('header.elementos.afectados.linea.factura'),
					dataIndex : 'lineaFactura',
					hidden : !esBBVA,
					flex : 1
				},
				{
					text : HreRem.i18n('header.activos.afectados.direccion'),
					dataIndex : 'direccion',
					flex : 1
				}, 
				{
					text : HreRem.i18n('header.activos.afectados.referencia.catastral'),
					dataIndex : 'referenciaCatastral',
					editor: {
						xtype: 'textfield',
						reference: 'comboReferenciaEditar'
					},
					flex : 1
				},{
					text : HreRem.i18n('header.activos.afectados.porcentaje.participacion.linea'),
					dataIndex : 'participacion',
					renderer: function(value) {
						const formatter = new Intl.NumberFormat('es-ES', {
	            		   minimumFractionDigits: 0,      
	            		   maximumFractionDigits: 4
	            		});
			          return formatter.format(value) + "%";
			        },
					flex : 1,
					editor: {
						xtype: 'numberfield',
						decimalPrecision: 4
					},
					summaryType: function(){
						var store = this;
	                    var records = store.getData().items;
	                    records = records.filter(function(value, index, self) { 
	                    	  return self.indexOf(value) === index;});
	                    var field = ['participacion'];
	                    
	                    if (this.isGrouped()) {
	                        var groups = this.getGroups();
	                        var i = 0;
	                        var len = groups.length;
	                        var out = {};
	                        var group;
	                        for (; i < len; i++) {
	                            group = groups[i];
	                            out[group.name] = sumaValores.apply(store, [group.children].concat(field));
	                        }
	                        var groupSum = out[groups[w].name];
	                        w++;
	                        return groupSum;
	                    } else {
	                        return sumaValores.apply(store, [records].concat(field));
	                    }
					},
		            summaryRenderer: function(value, summaryData, dataIndex) {
		            	const formatter = new Intl.NumberFormat('es-ES', {
		            		   minimumFractionDigits: 0,      
		            		   maximumFractionDigits: 4
		            		});
		            	var value2 = formatter.format(value);
		            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value2 + "%";
		            	var style = "style= 'color: black'";
		            	if(parseFloat(value).toFixed(4) != parseFloat('100.00')) {
		            		style = "style= 'color: red'";
		            	}			            	
		            	return "<span "+style+ ">"+msg+"</span>";
		            }
				}, {
					xtype: 'numbercolumn', 
					renderer: function(value) {
						const formatter = new Intl.NumberFormat('es-ES', {
	            		   minimumFractionDigits: 0,      
	            		   maximumFractionDigits: 2
	            		});
			          return formatter.format(value) + "\u20AC";
			        },
					text : HreRem.i18n('header.activos.afectados.importe.proporcional.total'),
					dataIndex : 'importeProporcinalSujeto',
					flex : 1,
					summaryType: 'sum',
		            summaryRenderer: function(value, summaryData, dataIndex) {
		            	const formatter = new Intl.NumberFormat('es-ES', {
		            		   minimumFractionDigits: 0,      
		            		   maximumFractionDigits: 2
		            	});
		            	var store = me.lookupController().getView().lookupReference('listadoActivosAfectadosRef').getStore();
		            	if(!Ext.isEmpty(store)){
			            	var dataStore = store.getData().items;
			            	var sumaValue = parseFloat(0.0);
			            	for(var i = 0; i < dataStore.length; i++){
			            		if(!Ext.isEmpty(dataStore[i].data)  && !Ext.isEmpty(dataStore[i].data.importeProporcinalSujeto)){
			            			sumaValue = sumaValue + parseFloat(dataStore[i].data.importeProporcinalSujeto);
			            		}
			            	}
			            	var value2 = formatter.format(sumaValue);
			            	var msg = HreRem.i18n("header.activos.afectados.importe.proporcional.total") + " " + value2 + "\u20AC";
			            	var style = "style= 'color: black'";
			            	var importeTotal = formatter.format(dataStore[0].get('importeTotalSujetoLinea'));
			            	if(importeTotal==""){
			            		importeTotal = formatter.format(0);
			            	}
			            	if(value2 != importeTotal) {
			            		style = "style= 'color: red'";
			            	}			            	
			            	return "<span "+style+ ">"+msg+"</span>"
		            	}
		            }
				},
				{
					text : HreRem.i18n('header.activos.afectados.cartera.bc'),
					dataIndex : 'carteraBc',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	}
				},
				{
					text : HreRem.i18n('header.activos.afectados.tipo.transmision'),
					dataIndex : 'tipoTransmision',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	} 
				},
				{
					text : HreRem.i18n('header.activos.afectados.subpartidas.edificacion'),
					dataIndex : 'subpartidaEdif',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	}
				},
				{
					text : HreRem.i18n('header.activos.afectados.grupo'),
					dataIndex : 'grupo',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	} 
				},
				{
					text : HreRem.i18n('header.activos.afectados.tipo'),
					dataIndex : 'tipo',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	} 
				},
				{
					text : HreRem.i18n('header.activos.afectados.subitpo'),
					dataIndex : 'subtipo',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	} 
				},
				{
					text : HreRem.i18n('header.activos.afectados.elemento.pep'),
					dataIndex : 'elementoPep',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	}
				},
				{
					text : HreRem.i18n('header.activos.afectados.codigo.promocion'),
					dataIndex : 'promocion',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
                	}
				},
				{
					text : HreRem.i18n('header.activos.afectados.situacion.comercial'),
					dataIndex : 'situacionComercial',
					flex : 1,
					bind:	{
						hidden:'{!esPropietarioCaixa}' 
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
	                store: '{storeElementosAfectados}'
	            }
	        }
	    ];
		me.callParent();
	},
	
	onAddClick: function(btn){
		var me = this;

		var idGasto= me.up('form').viewWithModel.getViewModel().get('gasto.id');
		var parent= me.up('form');
		var tieneSuplidos = me.lookupController().getView().getViewModel().getData().gasto.getData().suplidosVinculadosCod;
    	var tieneNumeroFacturaPrincipal = me.lookupController().getView().getViewModel().getData().gasto.getData().facturaPrincipalSuplido;
	
		if(!Ext.isEmpty(tieneSuplidos) && (tieneSuplidos  == CONST.COMBO_SIN_NO['SI'] || !Ext.isEmpty(tieneNumeroFacturaPrincipal))){
    		me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.crear.gasto.linea.detalle.con.activo")); 
    	}else{
			Ext.create('HreRem.view.gastos.AnyadirNuevoGastoActivo',{idGasto: idGasto, parent: parent}).show();
    	}
    },
    
    onDeleteClick: function(record){
		var me = this;
		var idElemento = me.selection.data.id;
		var elementoVacio = me.selection.data.idElemento;
		var tieneSuplidos = me.lookupController().getView().getViewModel().getData().gasto.getData().suplidosVinculadosCod;
    	var tieneNumeroFacturaPrincipal = me.lookupController().getView().getViewModel().getData().gasto.getData().facturaPrincipalSuplido;
		
		if(Ext.isEmpty(elementoVacio)){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ok.linea.detalle.informacion"));
			return;
		}else if(!Ext.isEmpty(tieneSuplidos) && (tieneSuplidos  == CONST.COMBO_SIN_NO['SI'] || !Ext.isEmpty(tieneNumeroFacturaPrincipal))){
    		me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.eliminar.gasto.linea.detalle.con.activo")); 
    		return;
    	}
		var url =  $AC.getRemoteUrl('gastosproveedor/desasociarElementosAgastos');
		
		me.mask(HreRem.i18n("msg.mask.loading"));
		
		Ext.Ajax.request({		    			
		 		url: url,
		 		method: 'GET',
		 		params: {
		 			idElemento: idElemento
		 		},   		
		    	success: function(response, opts) {		    		
					me.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
					me.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));		

    	    		var gridActivosLbk = me.up('gastodetalle').down('contabilidadgasto').down('[reference=vImporteGastoLbkGrid]');
	 		        if(gridActivosLbk && gridActivosLbk.getStore()){
	 		        	var idGasto  =  me.lookupController().getView().getViewModel().get("gasto.id");
	 		        	gridActivosLbk.getStore().getProxy().setExtraParams({'idGasto':idGasto});
	 		        	gridActivosLbk.getStore().load();
	 		        }
		    	},
	   			failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		    },
    		    callback: function(records, operation, success) {
    		    	me.up('form').funcionRecargar();
    		    	me.unmask();
    			}
		});		
    },
    
    deleteSuccessFn: function() {
    	var me = this; 
    	me.up('form').funcionRecargar();
    	
    },
					    
   	saveSuccessFn: function () {
		var me = this;	
		me.up('form').funcionRecargar();
		return true;
	},
	
	evaluarEdicion: function() {
		var me = this;

		if($AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK'])) {
			me.rowEditing.clearListeners();
		}
    },
    
    editFuncion: function(editor, context, record){
      	var me = this;
    	var url =  $AC.getRemoteUrl('gastosproveedor/updateElementosDetalle');
    	var data = context.newValues;
    	var edicion = me.estadoParaEditar(me);
    	if(Ext.isEmpty(data.idLinea)){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ok.linea.detalle.informacion"));
			return;
		}
    	
    	if(!edicion){
    		me.getStore().load();
    		return;
    	}
    	
 
    	me.mask(HreRem.i18n("msg.mask.loading"));	
    	Ext.Ajax.request({		    			
            url: url,
            method: 'POST',
            params: {
            	id: data.id,
            	participacion:data.participacion,
            	referenciaCatastral: data.referenciaCatastral
            },  	
			success: function(a, operation, c){
				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				me.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
				me.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
				me.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
				me.down('toolbar').down('[itemId=addButton]').setDisabled(!edicion);

			},
			failure: function(a, operation){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			},
			callback: function(records, operation, success) {
				me.getStore().load()
				me.unmask();
			}
			
		});   	
    },
    
    estadoParaEditar: function(me){
    	
    	var estadoParaGuardar = me.lookupController().getView().getViewModel().getData().gasto.getData().estadoModificarLineasDetalleGasto;
    	var isGastoRefacturado = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPorOtroGasto;
    	var isGastoRefacturadoPadre = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPadre;
    	var suplidos = me.lookupController().getView().getViewModel().getData().gasto.getData().isGastoRefacturadoPadre;
    	var edicion = true;
    	
    	if(/*me.up('gastodetallemain').getViewModel().get('gasto.asignadoATrabajos') || */me.up('gastodetallemain').getViewModel().get('gasto.autorizado')){
    		edicion = false;
    	}
    	
		if( edicion && estadoParaGuardar && !isGastoRefacturado && !isGastoRefacturadoPadre){ 
			edicion = true;
		}else{
			edicion = false;
		}
		return edicion;
    }

});