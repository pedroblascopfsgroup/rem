Ext.define('HreRem.view.activos.detalle.DatosComunidadActivo', {
      extend : 'HreRem.view.common.FormBase',
      xtype : 'datoscomunidadactivo',
      reference : 'datoscomunidadactivo',
      cls			: 'panel-base shadow-panel',
      collapsed	: false,
      scrollable : 'y',
      refreshAfterSave: true,
      
      listeners: {
			boxready: function() { 
    			var me = this;
	    		me.lookupController().cargarTabData(me);
    		}
		},
	
	  recordName: "datosComunidad",
      recordClass: "HreRem.model.ActivoComunidadPropietarios",
      
      requires : ['HreRem.model.ActivoComunidadPropietarios', 'HreRem.model.HistoricoGestionGrid'],

      initComponent : function() {

        var me = this;
        me.setTitle(HreRem.i18n('title.comunidades.entidades'));
        
        var items= [

        
			         {
						xtype:'fieldsettable',
						title: HreRem.i18n('title.listado.entidades.integra.activo'),
						collapsible: false,
						items :	[
									{
									    xtype		: 'gridBase',
									    idPrincipal : 'activo.id',
									    colspan: 3,
									    topBar: $AU.userHasFunction('EDITAR_DATOS_COMUNIDAD_ACTIVO'),
									    removeButton: false,
									    reference: 'listadoEntidadesref',
										cls	: 'panel-base shadow-panel',
										secFunToEdit: 'EDITAR_GRID_LISTADO_FICHA_COMUNIDAD_ENTIDADES',
										bind: {
											store: '{storeEntidades}',
											topBar: '{!datosComunidad.unidadAlquilable}'
										},
										listeners : {
										    rowdblclick: 'onEntidadesListDobleClick'
										},
										viewConfig: { 
									        getRowClass: function(record) { 
									        	if(!Ext.isEmpty(record.get('fechaExclusion'))){
									        		return 'red-row-grid';
									        	}
									        } 
									    }, 
										
										columns: [
													{	  
											        	xtype: 'actioncolumn',
											            dataIndex: 'codigoProveedorRem',
											            text: HreRem.i18n('title.activo.administracion.numProveedor'),
											            flex: 1,
											            items: [{
												            tooltip: HreRem.i18n('tooltip.ver.proveedor'),
												            getClass: function(v, metadata, record ) {
												            		//return 'ico-user'
												            		return 'fa-user blue-medium-color'
												            },
												            handler: 'abrirPestanyaProveedor'
												        }],
												        renderer: function(value, metadata, record) {
												        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
												        },
											            flex     : 1,            
											            align: 'right',
											            hideable: false,
											            sortable: true
											       },
											       {    text: HreRem.i18n('header.subtipo'),
											        	dataIndex: 'subtipoProveedorDescripcion',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.nif'),
											        	dataIndex: 'nifProveedor',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.nombre'),
											        	dataIndex: 'nombreProveedor',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.estado'),
											        	dataIndex: 'estadoProveedorDescripcion',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.participacion'),
											        	dataIndex: 'participacion',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.fecha.inclusion'),
											        	dataIndex: 'fechaInclusion',
											        	formatter: 'date("d/m/Y")',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.fecha.exclusion'),
											        	dataIndex: 'fechaExclusion',
											        	formatter: 'date("d/m/Y")',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.pagos.retenidos'),
											        	dataIndex: 'pagosRetenidos',
											        	flex: 1,
											        	renderer: function(value) {
											        		return value == 1? 'Si' : 'No';
											        	}
											       },
											       {    text: HreRem.i18n('header.observaciones'),
											        	dataIndex: 'observaciones',
											        	flex: 1
											       },
											       {
											       		dataIndex: 'idProveedor',
											       		hidden: true
											       }
									    ],

									    dockedItems : [
									        {
									            xtype: 'pagingtoolbar',
									            dock: 'bottom',
									            displayInfo: true,
									            bind: {
									                store: '{storeEntidades}'
									            }
									        }
									    ]
									}
						]
				},
				{
				xtype:'fieldsettable',
						title: HreRem.i18n('title.datos.comunidad.propietarios.activo'),
						collapsible: false,
						items :	[
							{
										xtype: 'datefieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.fecha.comunicacion.comunidad'),
										bind : {
											value :'{datosComunidad.fechaComunicacionComunidad}',
											readOnly: '{datosComunidad.unidadAlquilable}'
										}
									}, 
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.envio.cartas'),
									   bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.envioCartas}',
									      readOnly: '{datosComunidad.unidadAlquilable}'
									    }
									},
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.num.cartas'),
									   bind : {
									      store : '{comboNumCartas}',
									      value : '{datosComunidad.numCartas}',
									      readOnly: '{datosComunidad.unidadAlquilable}'
									    }
									}, 
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.contacto.telefonico'),
									    bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.contactoTel}',
									      readOnly: '{datosComunidad.unidadAlquilable}'
									    }
									},
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.visita'),
									   bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.visita}',
									      readOnly: '{datosComunidad.unidadAlquilable}'
									    }
									}, 
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.burofax'),
									    bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.burofax}',
									      readOnly: '{datosComunidad.unidadAlquilable}'
									    }
									}, 
									{	xtype : 'comboboxfieldbasedd',
										fieldLabel : HreRem.i18n('fieldlabel.estado.localizacion'),
										reference: 'estadoLocalizacion',
		        						listeners:{
		        							select: 'onChangeChainedCombo',
		        							afterrender: 'usuarioLogadoEditar'
		        						},
									    bind : {
										    store : '{comboEstadoLocalizacion}',
										    value : '{datosComunidad.estadoLocalizacion}',
											rawValue : '{datosComunidad.estadoLocalizacionDescripcion}'
										},
										chainedStore: 'comboSubestadoGestionFiltered',
										chainedReference: 'subestadoGestion'
										   
									},
									{	xtype : 'comboboxfieldbasedd',
										fieldLabel : HreRem.i18n('fieldlabel.subestado.gestion'),
										reference: 'subestadoGestion',
										listeners:{
		        								afterrender: 'usuarioLogadoEditar'
		        						},
									    bind : {
										    store : '{comboSubestadoGestionFiltered}',
										    value : '{datosComunidad.subestadoGestion}',
		        							disabled: '{!datosComunidad.estadoLocalizacion}',
										    allowBlank: '{!datosComunidad.estadoLocalizacion}',
											rawValue : '{datosComunidad.subestadoGestionDescripcion}'
										}	
									},
									{
										xtype : 'datefieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.fechaEnvioCarta'),
										bind : {
											value: '{datosComunidad.fechaEnvioCarta}',
											readOnly: '{datosComunidad.unidadAlquilable}'
										}
									},
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.asistencia.junta.obligatoria'),
									    bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.asistenciaJuntaObligatoria}',
									      editable: '{esEditableAsistenciaJuntaObligatoria}'
									    }
									},
									{
										xtype: 'textareafieldbase',
					                	fieldLabel: HreRem.i18n('fieldlabel.observaciones.com.propietarios'),
					                	name: 'observacionesComPropietarios',
					                	reference: 'observacionesComPropietariosRef',
					                	bind: {
					                		value: '{datosComunidad.observacionesComPropietarios}'
					                	},
					                	colspan: 2,
					                	maxLength: 250
									}
						]
				},
				{
					xtype:'fieldsettable',
							title: HreRem.i18n('title.diario.de.gestion'),
							collapsible: false,
							items :	[
								{
									xtype: 'historicoDiarioGestionGrid'
									
								}
							]
					}
			]
			
			me.addPlugin({ptype: 'lazyitems', items: items });
	        me.callParent();

      },
      

      
       funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		if(!me.disabled) {
			Ext.Array.each(me.query('grid'), function(grid) {
	  			grid.getStore().load();
	  		});
		}
//		var comboEstadoLocalizacion = me.lookupController().getView().lookupReference('estadoLocalizacion');
//		var storeEstadoLocalizacion = me.lookupController().getViewModel().get("comboEstadoLocalizacion");
//		comboEstadoLocalizacion.bindStore(storeEstadoLocalizacion);
//		storeEstadoLocalizacion.load({
//			scope: this,
//			callback: function(records, operation, success) {
//				var estadoLocalizacion = me.lookupController().getViewModel().get('datosComunidad.estadoLocalizacion');
//				comboEstadoLocalizacion.setValue(estadoLocalizacion);
//			}
//		});
//		var comboSubestadoGestion = me.lookupController().getView().lookupReference('subestadoGestion');
//		var storeSubestadoGestion = me.lookupController().getViewModel().get("comboSubestadoGestion");
//		comboSubestadoGestion.bindStore(storeSubestadoGestion);
//		storeSubestadoGestion.load();
//		comboSubestadoGestion.setDisabled(!(me.lookupController().getViewModel().get('estadoLocalizacion').selection.data.codigo != null && me.lookupController().getViewModel().get('estadoLocalizacion').selection.data.codigo != ''));
   }
  });