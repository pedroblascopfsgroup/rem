Ext.define('HreRem.view.activos.detalle.ValoracionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'valoracionesactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'valoracionesactivoref',
    scrollable	: 'y',
    listeners: {
			boxready:'cargarTabData'
	},

	recordName: "datosValoraciones",
	
	recordClass: "HreRem.model.ActivoValoraciones",
    
    requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoValoraciones', 'HreRem.model.ActivoTasacion'],

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.valoraciones.precios'));
        var items= [

       			{  
       				
       				xtype:'fieldsettable',
    				title:'Valores vigentes',
    				defaultType: 'textfieldbase',
    				items :	[
						{
							xtype:'fieldset',
							height: 140,
							width: '99%',
							colspan: 1,
							//width: '33%',
							layout: {
						        type: 'table',
								columns: 1
							}, 
							defaultType: 'currencyfieldbase',
							title: 'Valores de adquisci&oacute;n',
							items: [
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion.no.judicial'),
							        	labelWidth: 200,
					                	width:		280,
					                	bind:		'{datosValoraciones.valorAdquisicion}',
					    				editable: false,
					                	secRolesPermToEdit: ['']
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.valor.adjudicacion.judicial'),
							        	labelWidth: 200,
					                	width:		280,
					                	bind:		'{datosValoraciones.importeAdjudicacion}',
					                	editable: false,
					                	secRolesPermToEdit: ['']
							        }
							        
							]
    					 
						},
						{
							xtype:'fieldset',
							colspan: 2,
							height: 140,
							layout: {
						        type: 'table',
								columns: 2,
								tdAttrs: {width: '50%'},
								tableAttrs: {
						            style: {
						                width: '100%'
										}
							    }
							}, 
							defaultType: 'currencyfieldbase',
							readOnly: true,
							title: 'Valores del propietario',
							items: [
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.valor.neto.contable'),
					                	width:		280,
					                	labelWidth: 180,
					                	bind:		'{datosValoraciones.importeNetoContProp}',
					                	colspan: 2,
					                	editable: false,
					                	secRolesPermToEdit: ['']
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.precio.aprobado.alquiler'),
							        	labelWidth: 180,
					                	width:		280,
					                	bind:		'{datosValoraciones.importePropAlquiler}',
					                	editable: false,
					                	secRolesPermToEdit: ['']
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.precio.aprobado.venta'),
					                	width:		280,
					                	labelWidth: 180,
					                	bind:		'{datosValoraciones.importePropVenta}',
					                	editable: false,
					                	secRolesPermToEdit: ['']
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.precio.minimo.alquiler'),
					                	width:		280,
					                	labelWidth: 180,
					                	bind:		'{datosValoraciones.importeMinPropAlquiler}',
					                	editable: false,
					                	secRolesPermToEdit: ['']
							        },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.precio.minimo.venta'),
					                	width:		280,
					                	labelWidth: 180,
					                	bind:		'{datosValoraciones.importeMinPropVenta}',
					                	editable: false,
					                	secRolesPermToEdit: ['']
							        }
							        
							]
    					 							
						},
						{
							xtype:'fieldsettable',
		    				title:'Valores comerciales',
		    				collapsed: false,
		    				colspan: 3,
		    				defaultType: 'currencyfieldbase',
		    				items :	[
		 							{ 
		 								fieldLabel: HreRem.i18n('fieldlabel.precio.publicacion.web'),
		 								width:		300,
		 								bind:		'{datosValoraciones.importePublicacion}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							},
		 							{ 
		 								fieldLabel: HreRem.i18n('fieldlabel.valor.tasacion.venta.inmediata'),
		 								width:		250,
		 								bind:		'{datosValoraciones.importeTasacionVenta}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							},
		 							{ 
		 								fieldLabel: HreRem.i18n('fieldlabel.valor.legal.vpo'),
		 								width:		250,
		 								bind:		'{datosValoraciones.importeLegalVpo}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							},
		 							{
		 								fieldLabel: HreRem.i18n('fieldlabel.precio.evento'),
		 								width:		250,
		 								bind:		'{datosValoraciones.importeEvento}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							},
		 							{ 
		 								fieldLabel: HreRem.i18n('fieldlabel.precio.subasta'),
		 								width:		250,
		 								bind:		'{datosValoraciones.importeSubasta}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							},
		 							{ 
		 								fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta'),
		 								width:		250,
		 								bind:		'{datosValoraciones.importeEstimadoVenta}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							},
		 							{ 
		 								fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.alquiler'),
		 								width:		250,
		 								bind:		'{datosValoraciones.importeEstimadoAlquiler}',
		 								editable: false,
					                	secRolesPermToEdit: ['']
		 							}
							]
						}
    				]
       			},
                {
   					title: HreRem.i18n('title.listado.precios'),
   				    xtype		: 'gridBase',
   					cls	: 'panel-base shadow-panel',
   					bind: {
   						store: '{storeValoraciones}'
   					},
   					colspan: 3,
   					columns: [
   					    {   text: HreRem.i18n('header.listado.precios.id'), 
   				        	dataIndex: 'id',
   				        	hidden:true,
   				        	flex:1 
   				        },
   				        {   text: HreRem.i18n('header.listado.precios.tipoPrecio'), 
   				        	dataIndex: 'tipoPrecioDescripcion',
   				        	flex:4
   				        },	
   				        {   text: HreRem.i18n('header.listado.precios.importe'),  
   				        	dataIndex: 'importe',
   				        	renderer: function(value) {
   				        		return Ext.util.Format.currency(value);
   				        	},
   				        	flex:2 
   				        },	
   				        {  
   				        	text: HreRem.i18n('header.listado.precios.fechaInicio'),  
   				        	dataIndex:	'fechaInicio',
   				        	formatter: 'date("d/m/Y")',
   				        	flex:2
   				        },
   				        {   
   				        	text: HreRem.i18n('header.listado.precios.fechaFin'),  
   				        	dataIndex:	'fechaFin',
   				        	formatter: 'date("d/m/Y")',
   				        	flex:2
   				        },
   				        {   text: HreRem.i18n('header.gestor'),  
   				        	dataIndex: 'gestor',
   				        	flex:2 
   				        },
   				        {   text: HreRem.i18n('header.observaciones'),  
   				        	dataIndex: 'observaciones',
   				        	flex:2 
   				        }
   				    ],
   				    dockedItems : [
   				        {
   				            xtype: 'pagingtoolbar',
   				            dock: 'bottom',
   				            displayInfo: true,
   				            bind: {
   				                store: '{storeValoraciones}'
   				            }
   				        }
   				    ]
   				},
   				{
   					xtype: 'formBase',
   					cls	: 'panel-base shadow-panel',
   					reference: 'formTasaciones',
   				    collapsed: false,
   				    colspan: 3,

   					recordName: "datosTasaciones",
   					
   					recordClass: "HreRem.model.ActivoTasaciones",
   				    
   				    requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoTasacion'],
   				    
   				    items: [
   				        {
	   					
	   					xtype: 'fieldsettable',
	   					title: 'Tasaciones',
	    				items: [
	    				   
			   				{
								xtype:'fieldsettable',
			    				title:'&Uacute;ltima tasaci&oacute;n',
			    				defaultType: 'textfieldbase',
			    				colspan: 3,
			    				items :	[
					   				{ 
					   					xtype: 'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.valor.ultima.tasacion'),
										width:		250,
										bind:		'{datosValoraciones.importeValorTasacion}',
					                	readOnly: true
									},
								    {
										xtype: 'datefieldbase',
										formatter: 'date("d/m/Y")',
										fieldLabel: HreRem.i18n('fieldlabel.fecha.ultima.tasacion'),
										width:		250,
										bind:		'{datosValoraciones.fechaValorTasacion}',
										readOnly: true
								    },
								    {
										fieldLabel: HreRem.i18n('fieldlabel.tipo.ultima.tasacion'),
										width:		250,
										bind:		'{datosValoraciones.tipoTasacionDescripcion}',
										readOnly: true
								    }
								 ]
			   				},			   					
			   						
			   				{		   				
			   					title: HreRem.i18n('title.listado.tasacion'),
			   				    xtype		: 'gridBase',
			   					cls	: 'panel-base shadow-panel',
			   					bind: {
			   						store: '{storeTasaciones}'
			   					},
			   					colspan: 3,
			   					columns: [
			   					    {   text: HreRem.i18n('header.listado.tasacion.id'), 
			   				        	dataIndex: 'id',
			   				        	flex:1 
			   				        },
			   				        {   text: HreRem.i18n('header.listado.tasacion.tipoTasacion'),
			   				        	dataIndex: 'tipoTasacionDescripcion',
			   				        	flex:4
			   				        },	
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.importe'),
			   				        	dataIndex: 'importeValorTasacion',
			   				        	renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	},
			   				        	flex:2 
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.fechaFin'),
			   				        	dataIndex:	'fechaValorTasacion',
			   				        	flex:2
			   				        },
			   				        {   
			   				        	text: HreRem.i18n('header.listado.tasacion.nomTasadora'),
			   				        	dataIndex:	'nomTasador',
			   				        	flex:3
			   				        }    	        
			   				    ],
			   				    dockedItems : [
			   				        {
			   				            xtype: 'pagingtoolbar',
			   				            dock: 'bottom',
			   				            displayInfo: true,
			   				            bind: {
			   				                store: '{storeTasaciones}'
			   				            }
			   				        }
			   				    ],
			   				    listeners: [
			   				        {rowdblclick: 'onTasacionListDobleClick'}
			   					    
			   		    		]
			   				},
		   				
			                {   
			       				xtype: 'fieldsettable',
			       				title: HreRem.i18n('title.detail.tasacion'),	
			       				reference: 'tasacion',
			       				colspan: 3,
			       				//hidden: true,
			       				defaultType: 'textfieldbase',
			       				items :
			       					[      				        				    
										{ 
											xtype: 'datefieldbase',
											formatter: 'date("d/m/Y")',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaTasacion'),
											width:		250,
											bind:		'{datosTasaciones.fechaInicioTasacion}',
											readOnly: true
										},
										{ 
											xtype: 'datefieldbase',
											formatter: 'date("d/m/Y")',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaSolTasacion'),
											width:		250,
											bind:		'{datosTasaciones.fechaSolicitudTasacion}',
											readOnly: true
										},
										{ 
											xtype: 'datefieldbase',
											formatter: 'date("d/m/Y")',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.fechaRecepcionTasacion'),
											width:		250,
											bind:		'{datosTasaciones.fechaRecepcionTasacion}',
											readOnly: true
										},
										{ 
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.codFirmaTasadora'),
											width:		250,
											bind:		'{datosTasaciones.codigoFirma}',
											readOnly: true
										},
										{ 
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.nomTasador'),
											width:		250,
											bind:		'{datosTasaciones.nomTasador}',
											readOnly: true
										},
										{
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorTasacion'),
											width:		250,
											bind:		'{datosTasaciones.importeValorTasacion}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeTasacionFin'),
											width:		250,
											bind:		'{datosTasaciones.importeTasacionFin}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeRepoNetoActual'),
											width:		250,
											bind:		'{datosTasaciones.costeRepoNetoActual}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeRepoNetoFin'),
											width:		250,
											bind:		'{datosTasaciones.costeRepoNetoFinalizado}',
											readOnly: true
										},
										{ 
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefMercadoEstado'),
											width:		250,
											bind:		'{datosTasaciones.coeficienteMercadoEstado}',
											readOnly: true
										},	       				     
										{ 
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefMercadoEstadoHom'),
											width:		250,
											bind:		'',
											readOnly: true
										},
										{
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.coefPondValorA�adido'),
											width:		250,
											bind:		'{datosTasaciones.coeficientePondValorAnanyadido}',
											readOnly: true
										},
										{ 
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.tipoTasacion'),
											width:		250,
											bind:		'{datosTasaciones.tipoTasacionDescripcion}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.valorReperSueloConst'),
											width:		250,
											bind:		'{datosTasaciones.valorReperSueloConst}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeConstConstruido'),
											width:		250,
											bind:		'{datosTasaciones.costeConstConstruido}',
											readOnly: true
										},
										{ 
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceDepreciacionFisica'),
											width:		250,
											bind:		'{datosTasaciones.indiceDepreFisica}',
											readOnly: true
										},
										{ 
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceDepreciacionFuncional'),
											width:		250,
											bind:		'{datosTasaciones.indiceDepreFuncional}',
											readOnly: true
										},
										{ 
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.indiceTotalDepreciacion'),
											width:		250,
											bind:		'{datosTasaciones.indiceTotalDepre}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeConstruccionDepreciada'),
											width:		250,
											bind:		'{datosTasaciones.costeConstDepreciada}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeUnitarioRepoNeto'),
											width:		250,
											bind:		'{datosTasaciones.costeUnitarioRepoNeto}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.costeReposicion'),
											width:		250,
											bind:		'{datosTasaciones.costeReposicion}',
											readOnly: true
										},
										{ 
											xtype: 'numberfieldbase',
											symbol: HreRem.i18n("symbol.porcentaje"),
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.porcentajeObra'),
											width:		250,
											bind:		'{datosTasaciones.porcentajeObra}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorTerminado'),
											width:		250,
											bind:		'{datosTasaciones.importeValorTerminado}',
											readOnly: true
										},
										{ 
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.identifTextoAsociado'),
											width:		250,
											bind:		'{datosTasaciones.idTextoAsociado}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorLegalFinca'),
											width:		250,
											bind:		'{datosTasaciones.importeValorLegalFinca}',
											readOnly: true
										},
										{ 
											xtype: 'currencyfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.detail.tasacion.importeValorSolar'),
											width:		250,
											bind:		'{datosTasaciones.importeValorSolar}',
											readOnly: true
										}
			
			       					 ]
			                   	}
			   		      ]
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
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
   }
   
   /**
     * @return record Activos model
     */
    /*getRecord: function() {
    	
    	var me = this;
    	
    	return me.record;
    	
    },*/
    
    /**
     * Setea todos los valores del detalle del activo, recorriendo los componentes que sean necesarios para ello.
     * @param {} record Activos model
     */
    /*setValuesRegistro: function(id) {
    	
    	var me = this;    
    	
    	if(!Ext.isEmpty(id)) {      		
    		
    		HreRem.model.ActivoValoraciones.load(id, {
			    success: function(activo) {
					me.loadRecord(activo);

			Ext.Array.each(me.query('textfieldbase'),
				function (field, index) 
					{ 
						field.fireEvent('update');});
				    }
				    
			}); 

    	}
    	
    	
								
    	
    }*/
    
});