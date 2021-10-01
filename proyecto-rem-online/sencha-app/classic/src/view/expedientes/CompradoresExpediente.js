Ext.define('HreRem.view.expedientes.CompradoresExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'compradoresexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'compradoresexpedienteref',
    scrollable	: 'y',
    //refreshAfterSave: true,
    listeners : {
		//boxready : 'cargarTabData'
	},
	requires : [ 'HreRem.model.ExpedienteComercial'],	
  
    recordName: "expediente",

	recordClass: "HreRem.model.ExpedienteComercial",
  
  

    initComponent: function () {
		var me = this;
		var tipoExpedienteAlquiler = CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
		var tipoExpedienteAlquilerNoComercial = CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER_NO_COMERCIAL"];
		var title = HreRem.i18n('title.compradores');
		var titlePorcentaje = HreRem.i18n('header.procentaje.compra');
		var msgPorcentajeTotal = HreRem.i18n("fieldlabel.porcentaje.compra.total");
		var msgPorcentajeTotalError = HreRem.i18n("fieldlabel.porcentaje.compra.total.error");
		var isAlquiler = false;
		var tipoDelExpediente = me.lookupViewModel().get('expediente.tipoExpedienteCodigo');
		var bloqueado = me.lookupViewModel().get('expediente.bloqueado');
		if(tipoDelExpediente === tipoExpedienteAlquiler || tipoDelExpediente === tipoExpedienteAlquilerNoComercial ){
			title = HreRem.i18n('title.inquilinos');
			titlePorcentaje = HreRem.i18n('header.procentaje.alquiler');
			msgPorcentajeTotal = HreRem.i18n("fieldlabel.porcentaje.alquiler.total");
			msgPorcentajeTotalError = HreRem.i18n("fieldlabel.porcentaje.alquiler.total.error");	
			isAlquiler = true;
		};

		me.setTitle(title);
		
		var coloredRender = function (value, meta, record) {
    		var borrado = record.get('borrado');
    		if(value){
	    		if (borrado) {
	    			if(meta.column.dataIndex=='porcentajeCompra'){
	    				return '<span style="color: #DF0101;">'+Ext.util.Format.number(value, '0.00%')+'</span>';
	    			}
	    			return '<span style="color: #DF0101;">'+value+'</span>';
	    		} else {
	    			if(meta.column.dataIndex=='porcentajeCompra'){
	    				return Ext.util.Format.number(value, '0.00%');
	    			}
	    			return value;
	    		}
    		} else {
    			if(borrado){
    				return '<span style="color: #DF0101;">-</span>';
    			}
	    		return '-';
	    	}
    	};
    	
    	var cartera= function(){
    		if(me.lookupViewModel().get('expediente.entidadPropietariaCodigo') == CONST.CARTERA['BANKIA'] && tipoDelExpediente != tipoExpedienteAlquiler  && tipoDelExpediente != tipoExpedienteAlquilerNoComercial ){
    			return false;
    		}else{
    			return true;
    		}
    	};  	

	
        var items= [

			{   
				xtype: 'fieldset',
            	title:  title,
            	items : [
            		{
						xtype: 'button',
						text: HreRem.i18n('btn.enviar.compradores'),
						handler: 'enviarTitularesUvem',
						margin: '10 5 5 10',
						bind: {
							disabled:'{habilitarBotonEnviar}',
							hidden: '{!esEditableCompradores}'
						}
					},
					{
						xtype: 'button',
						text: HreRem.i18n('btn.contraste.listas'),
						handler: 'contrasteListas',
						margin: '10 5 5 10',
						bind:{
							hidden: isAlquiler
						}
					},
					{
						xtype: 'button',
						text: HreRem.i18n('btn.validar.compradores'),
						handler: 'validarCompradores',
						margin: '10 5 5 10',
						visible:true,
						hidden: cartera(),
				        hideable: !cartera(),
						bind: {
//							hidden: '{!esEditableCompradores}',
							disabled: '{habilitarBotonValidar}'
						}			        
					},
                	{
					    xtype		: 'gridBase',
					    topBar		: $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES']) && !bloqueado,
					    reference: 'listadoCompradores',
						cls	: 'panel-base shadow-panel',
						activateButton: true,
						bind: {
							store: '{storeCompradoresExpediente}'
							,topBar: '{puedeCrearEliminarCompradores}'
						},									
						listeners : {
					    	rowdblclick: 'onCompradoresListDobleClick',
							beforerender: 'esEditableCompradores',
							select: 'onSelectedRow',
					    	deselect: 'onDeselectedRow'
					    },
					    features: [{
				            id: 'summary',
				            ftype: 'summary',
				            hideGroupedHeader: true,
				            enableGroupingMenu: false,
				            dock: 'bottom'
					    }],
						columns: [
							{
						        xtype: 'actioncolumn',
						        reference: 'titularContratacio',
						        width: 30,
						        text: HreRem.i18n('header.principal'),
								hideable: false,
								items: [
								        	{
									            getClass: function(v, meta, rec) {
									                if (rec.get('titularContratacion') != 1) {
									                	this.items[0].handler = 'onMarcarPrincipalClick';
									                    return 'fa fa-check';
									                } else {
							            				this.items[0].handler = 'onMarcarPrincipalClick';
									                    return 'fa fa-check green-color';
									                }
									            }
								        	}
								 ]
				    		}, 
						   {    text: HreRem.i18n('header.id.cliente'),
					        	dataIndex: 'id',
					        	flex: 1,
					        	hidden: true,
					        	hideable: false
					       },
						   {
								text: HreRem.i18n('header.nombre.razon.social'),
								dataIndex: 'nombreComprador',
								flex: 1,
								renderer: coloredRender
						   },
						   {
						   		text: HreRem.i18n('header.numero.documento'),
					            dataIndex: 'numDocumentoComprador',
					            flex: 1,
					            renderer: coloredRender
						   },						   
						   {
						   		text: HreRem.i18n('header.representante'),
					            dataIndex: 'nombreRepresentante',
					            flex: 1,
					            renderer: coloredRender
						   },
						   {    text: HreRem.i18n('header.numero.documento'),
					        	dataIndex: 'numDocumentoRepresentante',
					        	flex: 1,
					        	renderer: coloredRender
					       },
						   {
								text:  titlePorcentaje,
								dataIndex: 'porcentajeCompra',
								flex: 1,
								renderer: coloredRender,
					            summaryType: 'sum',
					            summaryRenderer: function(value, summaryData, dataIndex) {
					            	var suma = this.up('grid').store.porcentajeCompra;

					            	suma = Ext.util.Format.number(suma, '0.00');
					            	
					            	var msg = msgPorcentajeTotal + " " + suma + "%";
					            	var style = "" 
					            	if(suma != Ext.util.Format.number(100.00,'0.00')) {
					            		msg = msgPorcentajeTotalError;		
					            		style = "style= 'color: red'" 
					            	}	
					            	
					            	return "<span "+style+ ">"+msg+"</span>"
					            	
					            }
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.grado.propiedad'),
					            dataIndex: 'descripcionGradoPropiedad',
					            flex: 1,
					            renderer: coloredRender
						   },
						   {
						   		text: HreRem.i18n('header.telefono'),
					            dataIndex: 'telefono',
					            flex: 1,
					            renderer: coloredRender
						   },						   
						   {
						   		text: HreRem.i18n('header.email'),
					            dataIndex: 'email',
					            flex: 1,
					            renderer: coloredRender
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.estado.pbc'),
					            dataIndex: 'descripcionEstadoPbc',
					            flex: 1,
					            hidden: true,
					            renderer: coloredRender
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.relacion.hre'),
					            dataIndex: 'relacionHre',
					            flex: 1,
					            renderer: coloredRender
						   },
						   {
						   		text: HreRem.i18n('header.compradores.numero.factura'),
					            dataIndex: 'numFactura',
					            flex: 1,
					            renderer: coloredRender
						   },
						   {
						   		text: HreRem.i18n('header.compradores.fecha.factura'),
					            dataIndex: 'fechaFactura',
					            flex: 1,
					            formatter: 'date("d/m/Y")',
					            renderer: coloredRender
						   },
						   {

							   text: HreRem.i18n('header.numero.ursus'),
							   dataIndex: 'numeroClienteUrsus',
							   flex: 1,
					           renderer: coloredRender,
					           hidden: cartera(),
					           hideable: !cartera()
						   },{
							   xtype: 'actioncolumn',
							      width: 30,
							      flex: 1,
							      hideable: false,
							      text: HreRem.i18n('grid.documento.gdpr'),
							        items: [{
							           	iconCls: 'ico-download',
							           	tooltip: "Documento GDPR",
							            handler: function(grid, rowIndex) {
							            	var record = grid.getRecord(rowIndex);
								            var grid = me.down('gridBase');
								               
								             grid.fireEvent("download", grid, record);	
							               
							          					                
					            		}
							        }]
						   } , {

							   text: HreRem.i18n('header.problemas.ursus'),
							   dataIndex: 'problemasUrsus',
							   flex: 1,
					           renderer: coloredRender,
					           hidden: cartera(),
					           hideable: !cartera()
						   },{

							   text: HreRem.i18n('header.fecha.acep.gpdr'),
							   dataIndex: 'fechaAcepGdpr'
						   },
						   {

							   text: HreRem.i18n('header.estado.contraste'),
							   dataIndex: 'descripcionEstadoECL',
							   flex: 1,
					           renderer: coloredRender
					          
						   } ,
						   {
						   
						        xtype: 'actioncolumn',
						        reference: 'tickEstadoContraste',
						        width: 30,
						        text: 'Estado Contraste',
								hideable: false,
								items: [
								        	{
								        		//NS NO solicitado  , PEND Pendietne , NEG Negativo , FP	Falso Positivo,PRA	Positivo real aprobado,PRD	Positivo real denegado
									            getClass: function(v, meta, rec) {
									                if (rec.get('codigoEstadoEcl') == CONST.ESTADO_CONT_LISTAS["NEGATIVO"] || rec.get('codigoEstadoEcl') == CONST.ESTADO_CONT_LISTAS["FALSO_POSITIVO"]) {
									                    return 'app-tbfiedset-ico icono-cross-green';			         
									                } else if(rec.get('codigoEstadoEcl') == CONST.ESTADO_CONT_LISTAS["POSITIVO_REAL_DENEGADO"]){
									                    return 'app-tbfiedset-ico icono-cross-ko';
									                }else if(rec.get('codigoEstadoEcl') == CONST.ESTADO_CONT_LISTAS["POSITIVO_REAL_APROBADO"]){
									                	return 'app-tbfiedset-ico icono-cross-yellow';
									                }else{
									                	return '';
									                }
									                	
									                
									            }
								        	}
								 ]
				    		},	 {

							   text: HreRem.i18n('header.fecha.contraste'),
							   dataIndex: 'fechaContraste',

							   flex: 1,
					           renderer: coloredRender,
					           formatter: 'date("d/m/Y h:i")'
						   },
						   {

							   text: HreRem.i18n('header.estado.bc'),
							   dataIndex: 'estadoComunicacionBCDescripcion',
							   flex: 1,
					           renderer: coloredRender
					          
						   } 

						  ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeCompradoresExpediente}'
					            }
					        }
					    ],
					    onClickAdd: function (btn) {
							var me = this;
							var controller= me.lookupController();
							controller.abrirFormularioCrearComprador(me);											    				    	
						}
					}
            	]
			} 
			
			// HREOS - 939 Fuera de alcance detalle PBC
			/*,{
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',
				reference: 'estadoPbcCompradoRef',
				title: HreRem.i18n('title.detalle.pbc'),
				items :
					[
					
						{
						xtype:'fieldsettable',
						layout: {
							type: 'table',
							columns: 2,
							width: 200
						},
						collapsible: false,
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	width: 500,
									border: false,
									defaultType: 'textfieldbase',
									items :
										[
											{			
											    xtype		: 'gridBase',
											    features: [{ftype:'grouping'}],
											    reference: 'listadoDocumentosExpediente',
												cls	: 'panel-base shadow-panel',
												bind: {
													//store: '{storeDocumentosExpediente}'
												},
												columns: [
												
													{
												        xtype: 'actioncolumn',
												        width: 30,	
												        hideable: false,
												        items: [{
												           	iconCls: 'ico-download',
												           	tooltip: HreRem.i18n("tooltip.download"),
												            handler: function(grid, rowIndex, colIndex) {
												                var grid = me.down('gridBase'),
												                record = grid.getStore().getAt(rowIndex);
												               
												                grid.fireEvent("download", grid, record);					                
										            		}
												        }]
										    		},
												    {   text: HreRem.i18n('header.documento'),
											        	dataIndex: 'documento',
											        	flex: 4
											        },
											        {   text: HreRem.i18n('header.aplica'),
											        	dataIndex: 'aplica',
											        	flex: 1,
											        	width: 50
											        },
											        {   text: HreRem.i18n('header.obtenido'),
											        	dataIndex: 'obtenido',
											        	flex: 1,
											        	width: 50
											        }
											    ]
				
	         			 					}	
				
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	border: false,
						        	layout: {
										type: 'table',
										columns: 2,
										width: 200
									},
									defaultType: 'textfieldbase',
									items :
										[
										{
											xtype:'fieldset',
						        			border: false,  
											defaultType: 'textfieldbase',
											items :
												[
										
													{
				                						fieldLabel:  HreRem.i18n('fieldlabel.responsable.tramitacion'),
				                						bind:		'{detalleComprador.responsableTramitacion}'
				               						},
												
													 { 
											        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
				                						bind:		'{detalleComprador.descripcionEstadoPbc}',
				    									readOnly: true
											        },
											        {	
													 	xtype:'datefieldbase',
													 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.peticion'),
							        					bind: '{detalleComprador.fechaPeticion}',
							        					readOnly: true
											        },
											        {	
													 	xtype:'datefieldbase',
													 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.resolucion'),
							        					bind: '{detalleComprador.fechaResolucion}',
							        					readOnly: true
											        }
											      ]
										},
										{
											xtype:'fieldset',
						        			border: false,
											defaultType: 'textfieldbase',
											items :
												[
									        {
							                	fieldLabel:  HreRem.i18n('fieldlabel.importe.proporcional.oferta'),
							                	bind:		'{detalleComprador.importeProporcionalOferta}',
							                	readOnly: true
					
							                },
							                {	
									        	xtype: 'numberfieldbase',
									        	symbol: HreRem.i18n("symbol.euro"),
							                	fieldLabel:  HreRem.i18n('fieldlabel.importe.financiado'),
							                	bind:		'{detalleComprador.importeFinanciado}'
							                },
							                { 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.destino.activo'),
									        	bind: {
								            		store: '{comboDestinoActivo}',
								            		value: '{detalleComprador.codUsoActivo}'
								            	},
								            	displayField: 'descripcion',
							    				valueField: 'codigo',
							    				allowBlank: false,
							    				listeners: {
							    					change: 'onHaCambiadoDestinoActivo'
							    				}
									        },
									        {	
									        	xtype: 'textfieldbase',
									        	reference: 'otrosDetallePbc',
							                	fieldLabel:  HreRem.i18n('fieldlabel.otros'),
							                	bind:		'{detalleComprador.otros}',
							                	allowBlank: false,
							                	disabled: '{!esDestinoActivoOtros}'
							                }
							                ]}

											
										]
						        	}
						        ]
					}
						
					    
		        ]
            }*/
          
    	];
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		//recargar grid
		var listadoCompradores = me.down("[reference=listadoCompradores]");
		listadoCompradores.getStore().load();
		
		me.lookupController().cargarTabData(me);

    }
    
    
});