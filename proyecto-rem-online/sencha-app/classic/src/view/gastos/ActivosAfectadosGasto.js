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
		me.setTitle(HreRem.i18n('title.gasto.activos.afectados'));
		var items = [
				
				{
					xtype : 'fieldsettable',
					border: false,
					collapsible: false,
					// bind: {
					// disabled: '{conEmisor}'
					// },
					items : [
		
						{
							xtype : 'textfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.activos.afectados.activo.id'),
							reference : 'buscadorActivoField',
							flex : 1,
							bind : {
								value : '{idBuscadorActivo}'
							},
							emptyText : 'Buscar Activo...',
							listeners : {
								change : 'onCambiaBuscadorActivo'
							}
						},
			
						{
							xtype : 'button',
							text : HreRem
									.i18n('fieldlabel.activos.afectados.incluir.activo'),
							margin : '0 0 10 0',
							reference: 'botonIncluirActivoRef',
							// handler: 'onClickBotonFavoritos'
							disabled : true
						},
						{
						},
						
						{
							xtype : 'textfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.activos.afectados.agrupacion.id'),
							reference : 'buscadorAgrupacionField',
							flex : 1,
							bind : {
								value : '{idBuscadorAgrupacion}'
							},
							emptyText : 'Buscar agrupación...',
							listeners : {
								change : 'onCambiaBuscadorAgrupacion'
							}
						},
						{
							xtype: 'button',
							text: HreRem.i18n('fieldlabel.activos.afectados.incluir.agrupacion'),
							margin: '0 0 10 0',
							reference: 'botonIncluirAgrupacionRef',
							// handler: 'onClickBotonFavoritos'
							disabled: true
						}
					]
				},
				

				{
					xtype : 'gridBaseEditableRow',
					// title: HreRem.i18n('title.notario'),
					reference : 'listadoActivosAfectadosRef',
					cls : 'panel-base shadow-panel',
					topBar: true,
					bind : {
						store : '{storeActivosAfectados}'
					},

					columns : [{
								dataIndex : 'idActivo',
								flex : 1,
								hidden : true,
								hideable : false
							}, {
								text : HreRem.i18n('header.activos.afectados.id.activo'),
								dataIndex : 'numActivo',
								flex : 1
							}, {
								text : HreRem.i18n('header.activos.afectados.referencia.catastral'),
								dataIndex : 'referenciaCatastral',
								flex : 1
							}, {
								text : HreRem.i18n('header.activos.afectados.subtipo.activo'),
								dataIndex : 'subtipoActivo',
								flex : 1
							}, {
								text : HreRem.i18n('header.activos.afectados.direccion'),
								dataIndex : 'direccion',
								flex : 1
							}, {
								text : HreRem.i18n('header.activos.afectados.porcentaje.participacion.gasto'),
								dataIndex : 'participacionGasto',
								flex : 1
							}, {
								text : HreRem.i18n('header.activos.afectados.importe.proporcional.total'),
								dataIndex : 'importeProporcionalTotal',
								flex : 1
							}

					],
					dockedItems : [{
								xtype : 'pagingtoolbar',
								dock : 'bottom',
								displayInfo : true,
								bind : {
									store : '{storeActivosAfectos}'
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
							
							Ext.create('HreRem.view.gastos.AnyadirNuevoGastoActivo',{idGasto: idGasto}).show();
							
					    }
					// listeners: {
					// rowdblclick: 'onNotarioDblClick'
					// }
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