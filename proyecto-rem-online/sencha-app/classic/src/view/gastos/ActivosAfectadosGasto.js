Ext.define('HreRem.view.gastos.ActivosAfectadosGasto', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'activosafectadosgasto',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	disableValidation : true,
	reference : 'activosafectadosgastoref',
	scrollable : 'y',
	//recordName : "gasto",

	// recordClass: "HreRem.model.GastoProveedor",
	//    
	 requires: ['HreRem.view.gastos.AnyadirNuevoGastoActivo'],
	//    
//	listeners: {
//		boxready:'cargarTabData'
//	},

	initComponent : function() {

		var me = this;
		
		var catastroStore = Ext.create('Ext.data.Store',{model: 'HreRem.model.ComboBase', autoload:false});
		
		me.setTitle(HreRem.i18n('title.gasto.activos.afectados'));
		var items = [

				{
					xtype : 'gridBaseEditableRow',
					reference : 'listadoActivosAfectadosRef',
					cls : 'panel-base shadow-panel',
					idPrincipal : 'id',
					topBar: true,
					bind : {
						store : '{storeActivosAfectados}'
					},

					columns : [
							
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
								dataIndex : 'participacionGasto',
								flex : 1,
								editor: {
									xtype:'numberfield'
								}
							}, {
								text : HreRem.i18n('header.activos.afectados.importe.proporcional.total'),
								dataIndex : 'importeProporcinalTotal',
								flex : 1
							}

					],
					
					dockedItems : [{
								xtype : 'pagingtoolbar',
								dock : 'bottom',
								displayInfo : true,
								bind : {
									store : '{storeActivosAfectados}'
								}
							}],
						onAddClick: function(btn){
							var me = this;
							
							var items= me.up('gastodetalle').getRefItems();
		
							for(var i=0;i<=items.length;i++){
								if(items[i].getXType()=='datosgeneralesgasto'){
									var recordDatosGenerales= items[i].getBindRecord();
									var idGasto= recordDatosGenerales.get('id');
									break;
								}
							}
							var parent= me.up('activosafectadosgasto');
							Ext.create('HreRem.view.gastos.AnyadirNuevoGastoActivo',{idGasto: idGasto, parent: parent}).show();
							
					    },
					    
					   	saveSuccessFn: function () {
							var me = this;
							return true;
						},
						listeners : {
							beforeedit : function(editor, e) {
								var me = this;
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
								var data = record.get("referenciasCatastrales").split(",");
								for (var i = 0; i < data.length; i++) {
									objeto = {
										descripcion : '' + data[i] + '',
										codigo : '' + data[i] + ''
									};
									objetoStore.push(objeto);
								};
								combo.getStore().setData(objetoStore);
							}
						}

				}

		];

		me.addPlugin({
					ptype : 'lazyitems',
					items : items
				});

		me.callParent();
	},
	

	funcionRecargar : function() {
		var me = this;
		me.recargar = false;
		
		var listadoActivosAfectados = me.down("[reference=listadoActivosAfectadosRef]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoActivosAfectados.getStore().load();
		
		//me.lookupController().cargarTabData(me);

	}
});