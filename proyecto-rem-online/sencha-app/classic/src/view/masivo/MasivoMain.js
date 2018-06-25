Ext.define('HreRem.view.masivo.MasivoMain', {
	extend		: 'Ext.container.Container',
	xtype		: 'masivomain',	
	cls			: 'masico-main',
	scrollable  : 'y',
	requires	: ['HreRem.view.masivo.MasivoController','HreRem.view.masivo.MasivoModel'],
	layout 		: {
		type : 'vbox',
		align : 'stretch'
	},
	controller	: 'masivo',
    viewModel	: {
        type: 'masivo'
    },

	initComponent: function() {
		var me = this;

		me.items = [
				{
					xtype: 'formBase',
					url: $AC.getRemoteUrl('process/upload'),					
					height: 160,
					bodyPadding: '20 10 10 10',
					title: HreRem.i18n('title.operaciones.plantillas'),
					cls	: 'panel-base shadow-panel',
					reference: 'cargamasivaFormRef',
					collapsed: false,
			 		scrollable	: 'y',
			 		layout: {
			 			type: 'vbox'
			 		},			 		
			 		buttonAlign: 'left',
    				buttons: [ 
    							{ formBind: true, itemId: 'btnUpload', text: 'Subir', handler: 'onClickBotonSubirMasivo'},
    							{ bind: {disabled: '{!comboTipoOperacionRef.selection}'}, itemId: 'btnDownload', text: 'Descargar plantilla', handler: 'onClickBotonDescargarPlantilla'}
    				],			 		
					items: [
	
				    		{ 
								xtype: 'combobox',
								reference:'comboTipoOperacionRef',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
					        	name: 'idTipoOperacion',
					        	editable: false,
					        	bind: {
				            		store: '{comboTipoOperacion}'
					        	},
				            	displayField	: 'descripcion',							    							
							    valueField		: 'id',
								allowBlank: false,
								width: '50%'
					        },
				    		{
						        xtype: 'filefield',
						        reference: 'filefieldMasivoRef',
						        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
						        name: 'fileUpload',
						        allowBlank: false,					        
							    anchor: '100%',
							    width: '100%',
							    msgTarget: 'side',
						        buttonConfig: {
						        	iconCls: 'ico-search-white',
						        	text: ''
						        },
						        align: 'right',
						        listeners: {
			                        change: function(fld, value) {
			                        	var lastIndex = null,
			                        	fileName = null;
			                        	if(!Ext.isEmpty(value)) {
				                        	lastIndex = value.lastIndexOf('\\');
									        if (lastIndex == -1) return;
									        fileName = value.substring(lastIndex + 1);
				                            fld.setRawValue(fileName);
			                        	}		                            	
			                        }
			                    },
								width: '50%',
								regex: /(.)+((\.xls)(\w)?)$/i,
        						regexText: HreRem.i18n("msg.validacion.archivos.xls")
				    		}
				    	]
				},
				{
					xtype	 : 'gridBase',
					flex	 : 1,
					title	 : HreRem.i18n("title.listado.archivos.procesamiento"),
				    reference: 'listadoCargamasiva',
					bind: {
						store: '{storeListadoProcesos}'
					},
					listeners: {
						select : 'onSelectProcesoCargaMasiva'
					},
					columns: [				

					    {
					    	text: HreRem.i18n('header.tipo'),
				        	dataIndex: 'tipoOperacion',
				        	sortable: true,
				        	flex: 1
				        },
				        {
				        	text: HreRem.i18n('header.estado'),
				        	dataIndex: 'estadoProceso',
				        	sortable: true,
				        	flex: 0.7
				        },
						{
				            text: HreRem.i18n('header.nombre.archivo'),
				            dataIndex: 'nombre',
				            sortable: true,
				            flex: 1
				        },
				        {
				        	text: HreRem.i18n('header.usuario'),
				        	dataIndex: 'usuario',
				            sortable: true,
				        	flex: 0.7
				        },
				        {
				        	text: HreRem.i18n('header.fecha.creacion'),
				        	dataIndex: 'fechaCrear',
				        	sortable: true,
				        	flex: 1,
				            formatter: 'date("d/m/Y H:i:s")'
				        },
				        {
				        	text: HreRem.i18n('header.filas.total'),
				        	dataIndex: 'totalFilas',
				        	sortable: true,
				        	flex: 0.3
				        },
				        {
				        	text: HreRem.i18n('header.filas.ok'),
				        	dataIndex: 'totalFilasOk',
				        	sortable: true,
				        	flex: 0.3
				        },
				        {
				        	text: HreRem.i18n('header.filas.ko'),
				        	dataIndex: 'totalFilasKo',
				        	sortable: true,
				        	flex: 0.3
				        }
					],

				    dockedItems : [
					    {
					    	xtype: 'toolbar',
					    	dock: 'top',
					    	items: [
						    	{
							       	itemId:'validarButton',
							       	cls: 'tbar-grid-button',
							       	handler: 'onClickBotonValidar',
							       	disabled: true,
							       	text: 'Validar'
							    },
					    		{
						        	itemId:'procesarButton',
						        	cls: 'tbar-grid-button',
						        	handler: 'onClickBotonProcesar',
						        	disabled: true,
						        	text: 'Procesar'
						        },
						        {
						        	itemId:'removeButton',
						        	cls: 'tbar-grid-button',
						        	text: 'Eliminar',
						        	hidden: true
						        },
						        {
						        	itemId:'downloadButton',
						        	cls: 'tbar-grid-button',
						        	handler: 'onClickDescargarErrores',
						        	text: 'Descargar errores',
						        	disabled: true
						        },
						        {
						        	itemId:'resultadoButton',
						        	cls: 'tbar-grid-button',
						        	handler: 'onClickDescargarResultados',
						        	text: 'Descargar resultados',
						        	disabled: true
						        }
					    	]
					    },
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeListadoProcesos}'
				            }
				        }
				    ]
				}
		];

		me.callParent();
	}
});