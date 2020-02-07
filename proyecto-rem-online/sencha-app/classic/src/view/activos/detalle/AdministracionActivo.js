Ext.define('HreRem.view.activos.detalle.AdministracionActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'administracionactivo',   
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'administracionactivoref',
	scrollable	: 'y',	
	listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    	
    		if (!$AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) && !$AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION']) && !$AU.userIsRol(CONST.PERFILES['HAYASUPER'])){
    			me.lookupController().lookupReference('tributosGrid').setEditOnSelect(false);
    			me.lookupController().lookupReference('tributosGrid').setTopBar(false);
    		}
    	}
    },
	
	requires: ['HreRem.model.ActivoAdministracion', 'HreRem.view.activos.detalle.ImpuestosActivoGrid', 'HreRem.model.ActivoTributos'],

    recordName: "administracion",

	recordClass: "HreRem.model.ActivoAdministracion",

    initComponent: function () {
        var me = this;

        me.setTitle(HreRem.i18n('title.administracion.activo'));

        var items= [
			{
				xtype: 'container',
				style: {
					backgroundColor: '#E5F6FE'
				},
				padding: 10,
				margin: '5 0 10 0',
				layout: {
					type: 'hbox'
				},
				items: [
					{
						xtype: 'checkboxfieldbase',
						bind:		'{administracion.ibiExento}',
						width: 40,
						disabled: '{administracion.isUnidadAlquilable}'
					},
					{
						xtype: 'label',
						cls: 'label-read-only-formulario-completo',
						html: HreRem.i18n('fieldlabel.activo.administracion.ibi.exento')						
					}
				]
			},
         
         {
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.proveedores'),
			collapsible: false,
			items :	[
				{
				    xtype		: 'gridBase',
				    idPrincipal : 'id',
				    colspan: 3,
				    reference: 'listadoproveedoresref',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeProveedores}'
					},
					listeners : {
					    	rowclick: 'onProveedoresListClick'
					},
					viewConfig: { 
				        getRowClass: function(record) { 
				        	if(!Ext.isEmpty(record.get('fechaExclusion'))){
				        		return 'red-row-grid';
				        	}
				        } 
				    },
					columns: [
						{    text: HreRem.i18n('title.activo.administracion.numActivo'),
				        	dataIndex: 'numActivo',
				        	hidden: false,
				        	hideable: false,
				        	flex: 1
				       },
						{
				        	xtype: 'actioncolumn',
				            dataIndex: 'codigoProveedorRem',
				            text: HreRem.i18n('title.activo.administracion.numProveedor'),
				            flex: 1,
				            items: [{
					            tooltip: HreRem.i18n('tooltip.ver.proveedor'),
					            getClass: function(v, metadata, record ) {
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
					   {    text: HreRem.i18n('title.activo.administracion.numProveedor'),
				        	dataIndex: 'codigoProveedor',
				        	hidden: true,
				        	hideable: false,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.tipo'),
				        	dataIndex: 'tipoProveedorDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
				        	dataIndex: 'subtipo',
				        	hidden: true,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.nif'),
				        	dataIndex: 'numDocumentoProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.nombre'),
				        	dataIndex: 'nombreProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.estado'),
				        	dataIndex: 'estadoProveedorDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.fecha.exclusion'),
				        	dataIndex: 'fechaExclusion',
				        	formatter: 'date("d/m/Y")',
				        	flex: 1
				       }
				    ],

				    dockedItems : [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeProveedores}'
				            }
				        }
				    ]
				},
				{
					xtype: 'displayfieldbase',
					value: HreRem.i18n('title.activo.administracion.mensaje.proveedor.excluido'),
				    flex: 1
				}
			]
		},
		{
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.listado.gastos'),
			collapsible: false,
			items :	[
				{
				    xtype		: 'gridBase',
				    idPrincipal : 'idGasto',
				    colspan: 3,
				    reference: 'listadogastosref',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeGastosProveedor}',
						disabled: '{administracion.isUnidadAlquilable}'
					},
					listeners: {
						rowdblclick: 'onClickAbrirGastoProveedor'	
					},
					columns: [
						{	  
				            text: HreRem.i18n('title.activo.administracion.numGasto'),				            
				            dataIndex: 'numGasto',
				            flex: 1,				            
				            hideable: false
					   },
					   {    text: HreRem.i18n('title.activo.administracion.numFactura'),
				        	dataIndex: 'numFactura',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.tipo'),
				        	dataIndex: 'tipoGastoDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
				        	dataIndex: 'subtipoGastoDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.concepto'),
				        	dataIndex: 'conceptoGasto',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.fecha.emision'),
				        	formatter: 'date("d/m/Y")',
				        	dataIndex: 'fechaEmisionGasto',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.periodicidad'),
				        	dataIndex: 'periodicidadGastoDescripcion',
				        	flex: 1
				       },
				        {    text: HreRem.i18n('title.activo.administracion.porcentajeParticipacion'),
				        	dataIndex: 'participacion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.importe.total'),
				        	dataIndex: 'importeTotalGasto',
				        	renderer: Utils.rendererCurrency,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.estado'),
				        	dataIndex: 'estadoGastoDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.fecha.pago'),
				        	formatter: 'date("d/m/Y")',
				        	dataIndex: 'fechaPagoGasto',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.afecta.otros.activos'),
				        	renderer: function(val, meta, record){
							    if(!Ext.isEmpty(record.data.participacion) && record.data.participacion!="100.0"){
							    	return "SI";
							    }
							    return "NO";
							},
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.observaciones'),
				        	dataIndex: 'observacionesGastos',
				        	flex: 1
				       }
				    ],
	
				    dockedItems: [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeGastosProveedor}'
				            }
				        }
				   ]
				}
			]
	},
		{
			xtype:'fieldsettable',
			title:HreRem.i18n('title.administracion.activo.tipo.impuesto'),
			defaultType: 'textfieldbase',
			colspan: 3,
			items :
				[
					{
						xtype: "impuestosactivogrid", reference: "impuestosactivogrid",
						bind:{
							disabled: '{administracion.isUnidadAlquilable}'
						}
					}
				]
		},
		{   
			xtype:'fieldsettable',
			reference: 'tributos',
			title: HreRem.i18n('title.administracion.activo.tributos'),
			collapsible: false,
			items :
				[
					{
						xtype		: 'gridBaseEditableRow',
				    	idPrincipal : 'activo.id',
				    	topBar: true,
				    	colspan: 3,
				    	reference: 'tributosGrid',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeActivoTributos}'
						},
						listeners:{
							rowclick: 'onTributoClick',
							deselect: 'deselectTributo'
						},
						features: [{
		            		id: 'summary',
		            		ftype: 'summary',
		           			hideGroupedHeader: true,
		            		enableGroupingMenu: false,
		            		dock: 'bottom'
						}],
						columns: [
						{   text: 'id',
				        	dataIndex: 'idTributo',
				        	hidden: true,
				        	hideable: false,
				        	flex: 1
				        },
				       	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.presentacion.recurso'),				            
				            dataIndex: 'fechaPresentacion',
				            flex: 1,
				            formatter: 'date("d/m/Y")',
			        		editor: {
		                   	 xtype: 'datefield',
		                   	 allowBlank: false
		                	}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.propietario'),				            
				            dataIndex: 'fechaRecPropietario',
				            flex: 1,
				            formatter: 'date("d/m/Y")',
			        		editor: {
		                   	 xtype: 'datefield',
		                 	 allowBlank: false
		                	}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.gestoria'),			            
				            dataIndex: 'fechaRecGestoria',
				            flex: 1,
				            formatter: 'date("d/m/Y")',
			        		editor: {
		                   	 xtype: 'datefield',
		                   	 allowBlank: false
		                	}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.tipo.solicitud'),		            
				            dataIndex: 'tipoSolicitud',
				            flex: 1,
				            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
				            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboTipoSolicitud').findRecord('codigo', value);
				            	var descripcion;
				        		if(!Ext.isEmpty(foundedRecord)) {
				        			descripcion = foundedRecord.getData().descripcion;
				        		}
				            	return descripcion;
				        	},
			        		editor: {
			        			xtype: 'comboboxfieldbase',
								addUxReadOnlyEditFieldPlugin: false,
				        		   labelWidth: '25%',
						            width: '15%',
				            		allowBlank: false,
					        	
				        		bind: {
				            		store: '{comboTipoSolicitud}',
				            		value: '{tipoSolicitud}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
			        		}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.observaciones'),		            
				            dataIndex: 'observaciones',
				            flex: 1,
				            editor: {
					           xtype:'textarea'
					        }
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.recurso.propietario'),		            
				            dataIndex: 'fechaRecRecursoPropietario',
				            flex: 1,
				            formatter: 'date("d/m/Y")',
			        		editor: {
		                   	 xtype: 'datefield',
		                   	 allowBlank: false
		                	}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.recepcion.recurso.gestorias'),	            
				            dataIndex: 'fechaRecRecursoGestoria',
				            flex: 1,
				            formatter: 'date("d/m/Y")',
			        		editor: {
		                   	 xtype: 'datefield',
		                   	 allowBlank: false
		                	}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.fecha.respuesta.recurso'),	            
				            dataIndex: 'fechaRespRecurso',
				            flex: 1,
				            formatter: 'date("d/m/Y")',
			        		editor: {
		                   	 xtype: 'datefield',
		                   	 allowBlank: false
		                	}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.resultado.solicitud'),            
				            dataIndex: 'resultadoSolicitud',
				            flex: 1,
				            renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
				            	var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboResultadoSolicitud').findRecord('codigo', value);
				            	var descripcion;
				        		if(!Ext.isEmpty(foundedRecord)) {
				        			descripcion = foundedRecord.getData().descripcion;
				        		}
				            	return descripcion;
				        	},
				            editor: {
				            	xtype: 'comboboxfieldbase',
								addUxReadOnlyEditFieldPlugin: false,
				        		   labelWidth: '25%',
						            width: '15%',
				            		allowBlank: false,
					        	
				        		bind: {
				            		store: '{comboResultadoSolicitud}',
				            		value: '{resultadoSolicitud}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
			        		}
					   	},
					   	{	  
				            text: HreRem.i18n('fieldlabel.administracion.activo.num.gasto.vinculado'),           
				            dataIndex: 'numGastoHaya',
				            flex: 1,
				            editor: {
			   					xtype:'numberfield', 
			        			hideTrigger: true,
			        			keyNavEnable: false,
			        			mouseWheelEnable: false		   				        		
			   				}
					   	},
					   	{	  
				            text: 'ExisteDocumento',
				            reference: 'existeDocumentoTributo',
				            dataIndex: 'existeDocumentoTributo',
				            flex: 0.5,
				            editor: {
				        		xtype:'textarea',
				        		readOnly: true
			        		}
					   	},
					   	{	  
					   		text: HreRem.i18n('fieldlabel.administracion.activo.numero.tributo'),
				            flex: 0.5,
				            dataIndex: 'numTributo',
				            readOnly: true 
					   	}
					   	/*{
				        	xtype: 'actioncolumn',
				            dataIndex: 'documentoTributoNombre',
				            reference: 'existeDocumentoTributoPorNombre',
				            text: 'Documento',
				            flex: 1.5,
				            items: [{
						            tooltip:'Añadir',
						            getClass: function(v, metadata, record ) {
						            		return 'ico-upload-documento'
						            },
						            handler: 'anyadirAdjuntoTributo'
					        	},
					        	{
						            tooltip:'Eliminar',
						            getClass: function(v, metadata, record ) {
						            		return 'ico-delete-documento'
						            },
						            handler: 'eliminarAdjuntoTributo'
						        },
						        {
						            tooltip:'Descargar',
						            getClass: function(v, metadata, record ) {
						            		return 'ico-download'
						            },
						            handler: 'descargarAdjuntoTributo'
						        }
					        ],
					        renderer: function(value, metadata, record) {
					        	if(value != undefined && value  != "No existe acceso al Gestor Documental"){
					        		return '<div style="float:right; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
					        	}else if(value  == "No existe acceso al Gestor Documental"){
					        		return '<div style="float:right; margin-top:3px; font-size: 11px; line-height: 1em; color:red;">'+ value+'</div>';
					        	}
					        	
					        	return null;
					        },
				            flex     : 1,            
				            align: 'left',
				            hideable: false,
				            sortable: true
				       }*/
					   	],
					   	dockedItems: [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeActivoTributos}'
				            }
				        }
				   ]
			
				},
				{
					title: 'Documentos de tributos',
					xtype:'documentostributosgrid'
				}		
				]
		}

								
    ];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
		me.lookupController().cargarTabData(me);
    }
});