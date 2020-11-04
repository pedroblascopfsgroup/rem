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
	requires: ['HreRem.view.gastos.AnyadirNuevoGastoActivo'],
	cls : 'panel-base shadow-panel',
	idPrincipal : 'id',
	bind : {
		store : '{storeActivosAfectados}'
	},
	listeners : {
		
		beforeedit : function(editor, e) {
			var me = this;
			if(!me.up('gastodetallemain').getViewModel().get('gasto.asignadoATrabajos')){
				var record = e.record;
				var columnas = me.getColumns();
				for (var i = 0; i < columnas.length; i++) {
					if (columnas[i].dataIndex == 'referenciaCatastral') {
						var columna = columnas[i];
					}
				}
				var combo = columna.getEditor();
	
				var objetoStore = [];
				var objeto = null;
				if(record.get("referenciasCatastrales")){
					var data = record.get("referenciasCatastrales").split(",");
					for (var i = 0; i < data.length; i++) {
						objeto = {
							descripcion : '' + data[i] + '',
							codigo : '' + data[i] + ''
						};
						objetoStore.push(objeto);
					};
				}
				combo.getStore().setData(objetoStore);
			}else{
				return false;
			}
		},
		
		boxready: function() {
			var me = this;
			me.evaluarEdicion();
		}
	},
	
	initComponent : function() {

		var me = this;
		
		var catastroStore = Ext.create('Ext.data.Store',{model: 'HreRem.model.ComboBase', autoload:false});

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
					dataIndex : 'idActivo',
					flex : 1,
					hidden : true,
					hideable : false
				}, {
					text : HreRem.i18n('header.activos.afectados.id.activo'),
					xtype: 'actioncolumn',
		        	dataIndex: 'numActivo',
			        items: [{
			            tooltip: HreRem.i18n('fieldlabel.ver.activo'),
			            getClass: function(v, metadata, record ) {
			            	return "app-list-ico ico-ver-activov2";
			            				            	
			            },
			            handler: 'onEnlaceActivosClick'
			        }],
			        renderer: function(value, metadata, record) {
			        		return '<div style="float:right; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        	
			        },
		            flex     : 1,            
		            align: 'left',
//		            menuDisabled: true,
		            hideable: false,
		            sortable: true
				}, {
					text : HreRem.i18n('header.activos.afectados.referencia.catastral'),
					dataIndex : 'referenciaCatastral',
					editor: {
						xtype: 'comboboxfieldbase',
						reference: 'comboReferenciaEditar',
						store: catastroStore,
						displayField: 'descripcion',
						addUxReadOnlyEditFieldPlugin: false,
    					valueField: 'codigo'
					},
					renderer: function(value, a, record, e) {
						return value;
					},
					flex : 1
				}, {
					text : HreRem.i18n('header.activos.afectados.subtipo.activo'),
					dataIndex : 'subtipoDescripcion',
					flex : 1
				}, {
					text : HreRem.i18n('header.activos.afectados.direccion'),
					dataIndex : 'direccion',
					flex : 1
				}, {
					xtype: 'numbercolumn',
					text : HreRem.i18n('header.activos.afectados.porcentaje.participacion.gasto'),
					dataIndex : 'participacion',
					renderer: function(value) {
						const formatter = new Intl.NumberFormat('es-ES', {
	            		   minimumFractionDigits: 2,      
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
		            		   minimumFractionDigits: 2,      
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
	            		   minimumFractionDigits: 2,      
	            		   maximumFractionDigits: 4
	            		});
			          return formatter.format(value) + "\u20AC";
			        },
					text : HreRem.i18n('header.activos.afectados.importe.proporcional.total'),
					dataIndex : 'importeProporcinalTotal',
					flex : 1,
					summaryType: function(){
						var store = this;
	                    var records = store.getData().items;
	                    var field = ['importeProporcinalTotal'];
	                    
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
		            		   minimumFractionDigits: 2,      
		            		   maximumFractionDigits: 2
		            		});
		            	var value2 = formatter.format(value);
		            	var msg = HreRem.i18n("header.activos.afectados.importe.proporcional.total") + " " + value2 + "\u20AC";
		            	var style = "style= 'color: black'";

		            	var importeTotal = 0;
		            	if(!Ext.isEmpty(me.store.getData().items[0])){
							importeTotal = me.store.getData().items[0].get('importeTotalGasto');
						}
		            	if(parseFloat(value).toFixed(2) != parseFloat(importeTotal).toFixed(2)) {		            		
		            		style = "style= 'color: red'";
		            	}			            	
		            	return "<span "+style+ ">"+msg+"</span>";
		            }

				}
		];
		
		me.callParent();
	},
	
	onAddClick: function(btn){
		var me = this;

		var idGasto= me.up('form').viewWithModel.getViewModel().get('gasto.id');
		var parent= me.up('form');
		Ext.create('HreRem.view.gastos.AnyadirNuevoGastoActivo',{idGasto: idGasto, parent: parent}).show();
		
    },
    
    onDeleteClick: function(){
		var me = this;
		
		var idGastoActivo = me.selection.data.id;
		var params = {};
		params.id = idGastoActivo;
		var url =  $AC.getRemoteUrl('gastosproveedor/deleteGastoActivo');
		
		Ext.Ajax.request({		    			
		 		url: url,
		   		params: params,	    		
		    	success: function(response, opts) {		    		
					var data = Ext.decode(response.responseText);
					if(!Ext.isEmpty(data) && data.success == "true") {
						me.up('form').funcionRecargar();
						me.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
						me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					} else {	
						me.up('form').funcionRecargar();
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					}
		    	},
	   			failure: function(response) {
	   				me.up('form').funcionRecargar();
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		    }
		});		
    },
    
    deleteSuccessFn: function() {
    	var me = this; 
    	//me.lookupController().updateGastoByPrinexLBK();	
    	me.up('form').funcionRecargar();
    	
    },
					    
   	saveSuccessFn: function () {
		var me = this;
		//me.lookupController().updateGastoByPrinexLBK();	
		me.up('form').funcionRecargar();
		return true;
	},
	
	evaluarEdicion: function() {
		var me = this;

		if($AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK'])) {
			me.rowEditing.clearListeners();
		}
    }

});