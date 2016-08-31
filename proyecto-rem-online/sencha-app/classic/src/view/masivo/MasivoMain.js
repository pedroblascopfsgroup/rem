Ext.define('HreRem.view.masivo.MasivoMain', {
	extend		: 'Ext.container.Container',
	xtype		: 'masivomain',	
	cls			: 'masico-main',
	scrollable  : 'y',
	
	requires: [
        'HreRem.view.masivo.MasivoController',
        'HreRem.view.masivo.MasivoModel'
    ],
	
	layout : {
		type : 'vbox',
		align : 'stretch'
	},
	
	controller: 'masivo',
    viewModel: {
        type: 'masivo'
    },
	
	initComponent: function() {
		
		
		var me = this;
		
		me.items = [
		
			
				{
					xtype: 'formBase',
					url: $AC.getRemoteUrl('process/initProcessUpload'),					
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
			 		
					xtype		: 'gridBase',
					flex		: 1,
					title		: HreRem.i18n("title.listado.archivos.procesamiento"),
				    reference: 'listadoCargamasiva',
					bind: {
						store: '{storeListadoProcesos}'
					},
					columns: [				
						
					    {   text: HreRem.i18n('header.tipo'),
				        	dataIndex: 'tipoOperacion',
				        	flex: 1,
				        	renderer: function (value) {
				        		return Ext.isEmpty(value) ? "" : value.descripcion;
				        	}
				        },
				        {   text: HreRem.i18n('header.estado'),
				        	dataIndex: 'estadoProceso',
				        	flex: 1,
				        	renderer: function (value) {
				        		return Ext.isEmpty(value) ? "" : value.descripcion;
				        	}
				        },	
						{
				            text: HreRem.i18n('header.nombre.archivo'),
				            dataIndex: 'descripcion',
				            flex: 1
				        },
				        {   text: HreRem.i18n('header.usuario'),
				        	dataIndex: 'auditoria',
				        	flex: 1,
				        	renderer: function (value) {
				        		return Ext.isEmpty(value) ? "" : value.usuarioCrear;
				        	}
				        },
				        {   text: HreRem.i18n('header.fecha.creacion'),
				        	dataIndex: 'auditoria',
				        	flex: 1,
				        	renderer: function (value) {
				        		return Ext.isEmpty(value) ? "" : value.fechaCrear
				        	}
				        }
					       	        
					],
					
				    dockedItems : [
					    {
					    	xtype: 'toolbar',
					    	dock: 'top',
					    	items: [
					    		{
						        	itemId:'procesarButton',
						        	cls: 'tbar-grid-button',
						        	handler: 'onClickBotonProcesar',
						        	text: 'Procesar'
						        },
						        {
						        	itemId:'removeButton',
						        	cls: 'tbar-grid-button',
						        	//handler: 'onClickAdd',
						        	text: 'Eliminar'
						        },
						        {
						        	itemId:'downloadButton',
						        	cls: 'tbar-grid-button',
						        	handler: 'onClickDescargarErrores',
						        	text: 'Descargar errores'
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