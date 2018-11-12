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
      
      requires : ['HreRem.model.ActivoComunidadPropietarios'],

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
											store: '{storeEntidades}'
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
										bind : '{datosComunidad.fechaComunicacionComunidad}'
									}, 
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.envio.cartas'),
									   bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.envioCartas}'
									    }
									},
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.num.cartas'),
									   bind : {
									      store : '{comboNumCartas}',
									      value : '{datosComunidad.numCartas}'
									    }
									}, 
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.contacto.telefonico'),
									    bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.contactoTel}'
									    }
									},
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.visita'),
									   bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.visita}'
									    }
									}, 
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.burofax'),
									    bind : {
									      store : '{comboSiNoRemActivo}',
									      value : '{datosComunidad.burofax}'
									    }
									}, {xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.situacion'),
									    bind : {
										      store : '{comboSituacionActivo}',
										      value : '{datosComunidad.situacionCodigo}'
										    }	
									},							
										{
										xtype : 'datefieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.fechaEnvioCarta'),
										bind : '{datosComunidad.fechaEnvioCarta}'
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
   }
  });