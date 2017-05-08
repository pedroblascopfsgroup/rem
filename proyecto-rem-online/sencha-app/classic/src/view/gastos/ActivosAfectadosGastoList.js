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
			}else return false;
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
					{itemId: 'removeButton', iconCls:'x-fa fa-minus', handler: 'onDeleteClick', bind: {hidden: '{ocultarBotonesActivos}'}, disabled: true, scope: this}
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
					text : HreRem.i18n('header.activos.afectados.porcentaje.participacion.gasto'),
					dataIndex : 'participacion',
					renderer: function(value) {
			          return Ext.util.Format.number(value, '0.00%');
			        },
					flex : 1,
					editor: 'numberfield',
					summaryType: 'sum',
		            summaryRenderer: function(value, summaryData, dataIndex) {
		            	var value2=Ext.util.Format.number(value, '0.00');
		            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value2 + "%";
		            	var style = "style= 'color: black'";
		            	if(value != 100) {
		            		//msg = HreRem.i18n("fieldlabel.participacion.total.error")	
		            		style = "style= 'color: red'";
		            	}			            	
		            	return "<span "+style+ ">"+msg+"</span>"
		            }
				}, {
					xtype: 'numbercolumn', 
					renderer: Utils.rendererCurrency,
					text : HreRem.i18n('header.activos.afectados.importe.proporcional.total'),
					dataIndex : 'importeProporcinalTotal',
					flex : 1,
					summaryType: 'sum',
		            summaryRenderer: function(value, summaryData, dataIndex) {
		            	var value2=Ext.util.Format.number(value, '0.00');
		            	var msg = HreRem.i18n("header.activos.afectados.importe.proporcional.total") + " " + value2 + "\u20AC";
		            	var style = "style= 'color: black'";
		            	var importeTotal = Ext.util.Format.number(me.up('gastodetallemain').getViewModel().get('gasto.importeTotal'), '0.00');
		            	if(importeTotal==""){
		            		importeTotal = Ext.util.Format.number(0, '0.00');
		            	}
		            	if(value2 != importeTotal) {
		            		//msg = HreRem.i18n("fieldlabel.participacion.total.error")	
		            		style = "style= 'color: red'";
		            	}			            	
		            	return "<span "+style+ ">"+msg+"</span>"
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
    
    deleteSuccessFn: function() {
    	var me = this;    	
    	me.up('form').funcionRecargar();
    	
    },
					    
   	saveSuccessFn: function () {
		var me = this;
		return true;
	}

});