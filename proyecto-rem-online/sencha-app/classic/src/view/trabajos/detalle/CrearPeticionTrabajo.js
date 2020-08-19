Ext.define('HreRem.view.trabajos.detalle.CrearPeticionTrabajo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'crearpeticiontrabajowin',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.8,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'crearpeticiontrabajowinref',
    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    requires: ['HreRem.model.FichaTrabajo','HreRem.view.trabajos.detalle.ActivosAgrupacionTrabajoList'],
   
    

    
	listeners: {

		boxready: function(window) {
			
			var me = this;
			
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
			
		},
		
		show: function() {	
			var me = this;
			me.resetWindow();			
		}

	},
	
	    
    
    idActivo: null,
    
    idAgrupacion: null,
    
    idProceso: null,
    
    codCartera: null,
    
    logadoGestorMantenimiento: null,
    
    gestorActivo: null,
    
    
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.peticion.trabajo.nuevo"));
    	
    	me.buttonAlign = 'left'; 
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonCrearPeticionTrabajo'},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindowCrearPeticionTrabajo'}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	   			 		scrollable	: 'y',
	    				cls:'',	    				
					    recordName: "trabajo",
						recordClass: "HreRem.model.FichaTrabajo",
					    
    					items: [
        							{    
				                
										xtype:'fieldsettable',
										collapsible: false,
										defaultType: 'textfieldbase',
										
										items :
											[
											{    
				                
												xtype:'fieldsettable',
												collapsible: false,
												border:0,
												colspan:2,
												defaultType: 'textfieldbase',
												
												items :
													[
													 {
													        xtype: 'textfieldbase',
													        readOnly: true,
													        fieldLabel: HreRem.i18n('fieldlabel.gestor.logado.nuevo.trabajo'),
													        reference:'gestorActivo',
															colspan: 3,
															padding:'2 2 2 2',
													        bind: 
													        	{
													            	value: me.gestorActivo
												            	}
												       },
	       												{
															xtype: 'datefieldbase',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.fecha.alta.nuevo.trabajo'),
															minValue: $AC.getCurrentDate(),
															maxValue: null,
															value:  $AC.getCurrentDate(),
															colspan: 3,
															allowBlank: false
														},
														{ 
												        	xtype: 'comboboxfieldbase',
												        	editable: false,
												        	fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
															reference: 'tipoTrabajo',
												        	chainedStore: 'comboSubtipoTrabajo',
															chainedReference: 'subtipoTrabajoCombo',
															colspan: 3,
												        	bind: 
												        		{
											            			store: '{storeTipoTrabajoCreaFiltered}',
											            			value: '{trabajo.tipoTrabajoCodigo}'
										            			},
								    						listeners: 
								    							{
											                		select: 'onChangeChainedCombo'
											            		},
											            	allowBlank: false
												        },
												        { 
															xtype: 'comboboxfieldbase',
												        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.trabajo'),
												        	reference: 'subtipoTrabajoCombo',
												        	colspan: 3,
												        	editable: false,
												        	bind: 
												        		{
										            				store: '{comboSubtipoTrabajo}',
											            			value: '{trabajo.subtipoTrabajoCodigo}',
											            			disabled: '{!trabajo.tipoTrabajoCodigo}'
											            		},
								    						listeners: 
								    							{
											                		select: 'onChangeSubtipoTrabajoCombo'
											            		},
															allowBlank: false
												        },
												        { 
															xtype: 'comboboxfieldbase',
												        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.trabajo'),
												        	colspan: 3,
												        	editable: false,
												        	bind: 
												        		{
											            		//store: '{comboGestorActivoResponsable}',
											            		//value: '{fieldlabel.proveedor.trabajo}'
											            		},
															allowBlank: false
												        }
													]
												},
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													border:0,
													colspan:1,
													items :
														[
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.aplica.comite.trabajo'),
																colspan: 3,
																checked: false
															},
															{ 
																xtype: 'comboboxfieldbase',
													        	fieldLabel:  HreRem.i18n('fieldlabel.resolucion.comite'),
													        	colspan: 3,
													        	editable: false,
																allowBlank: false
										        			},

															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.resolucion.comite.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																colspan: 3,
																allowBlank: false
															},
										        			{
														        xtype: 'textfieldbase',
														        fieldLabel: HreRem.i18n('fieldlabel.id.resolucion.comite'),
																colspan: 3,
																maxLength: 10
													       }
														]
												},				
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
													items :
														[
													        {
													            xtype : 'numberfieldbase',
													            fieldLabel : HreRem.i18n('fieldlabel.id.tarea.trabajo'),
													            allowBlank: false,
													            maxLength:10
				        									}
													]
												},
										        //GRID LISTADO ACTIVOS
												{    
				                
												xtype:'fieldsettable',
												collapsible: false,
												title: HreRem.i18n('title.publicaciones.activos.grid'),
												defaultType: 'textfieldbase',
												colspan:3,
												items :
													[
														{
															xtype: 'checkboxfieldbase',
															boxLabel: HreRem.i18n('fieldlabel.check.multiactivo'),
															checked: false,
															colspan: 3
														},
										    			{
														    xtype		: 'gridBase',
															cls	: 'panel-base shadow-panel',
															colspan:2,
															columns: [
													  				{
														            	text	 : HreRem.i18n('header.numero.activo'),
														                flex	 : 1,
														                dataIndex: 'numAgrupRem'
														            },
		
														            {
															            dataIndex: 'tipoAgrupacionDescripcion',
															            text: HreRem.i18n('header.tipologia'),
																		flex	: 1
															            
															        },
														            {
														         		text	 : HreRem.i18n('header.via'),
														                flex	 : 1
														            }
														    ],
											
														    dockedItems : [
														        {
														            xtype: 'pagingtoolbar',
														            dock: 'bottom',
														            displayInfo: true,
														            bind: 
														            	{
														                //store: '{storeAgrupacionesActivo}'
													        	    	}
														        }
														    ]
														}
													]
												},
												//GRID LISTADO TARIFAS
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													title: HreRem.i18n('title.publicaciones.tarifas.grid'),
													defaultType: 'textfieldbase',
													colspan:3,
													
													items :
														[
													
															{
															    xtype		: 'gridBase',
																cls	: 'panel-base shadow-panel',
																colspan:2,

																columns: [
														  				{
															            	text	 : HreRem.i18n('header.codigo.tarifa'),
															                flex	 : 1
															            },
			
															            {
																            text: HreRem.i18n('header.unidad.medicion'),
																			flex	: 1
																            
																        },
															            {
															         		text	 : HreRem.i18n('header.precio.unitario'),
															                flex	 : 1
															            }
															    ],
												
															    dockedItems : [
															        {
															            xtype: 'pagingtoolbar',
															            dock: 'bottom',
															            displayInfo: true,
															            bind: 
															            	{
															                //store: '{storeAgrupacionesActivo}'
															            	}
															        }
														    	]
															}
													]
												},

								                //PLAZOS
							                	{
								                	xtype:'fieldsettable',
													collapsible: false,
													colspan:3,
													title: HreRem.i18n('title.plazos.trabajo.nuevo'),
													defaultType: 'textfieldbase',
													items :
														[
															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.concreta.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																colspan:1,
																allowBlank: false
															},
															{
																xtype: 'timefieldbase',
																colspan:2,
																fieldLabel: HreRem.i18n('fieldlabel.hora.concreta.trabajo'),
																format: 'H:i',
																increment: 30,
																allowBlank: false
															},	
															{
																xtype: 'datefieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.fecha.tope.trabajo'),
																minValue: $AC.getCurrentDate(),
																maxValue: null,
																colspan:1,
																allowBlank: false
															}
														]
														
												},
												//PRESUPUESTO
							                	{
								                	xtype:'fieldsettable',
													collapsible: false,
													colspan: 3,
													title: HreRem.i18n('title.peticion.presupuesto.trabajo'),
													defaultType: 'textfieldbase',
													items :
														[
															{ 
																xtype: 'currencyfieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.precio.presupuesto')
											                },
											                { 
																xtype: 'currencyfieldbase',
																fieldLabel: HreRem.i18n('fieldlabel.referencia.presupuesto')
											                }
														]
														
												},
												//PARTE CHECKBOX
												{    
													xtype:'fieldsettable',
													collapsible: false,
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
													
													items :
														[
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.check.tarifaplana'),
																colspan:2,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.terceros'),
																colspan:1,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.urgente'),
																colspan:2,
																checked: false
															},
															{
																xtype: 'checkboxfieldbase',
																boxLabel: HreRem.i18n('fieldlabel.check.riesgo.siniestro'),
																colspan:1,
																checked: false
															}
														]
												
												},
												//PARTE DE DESCRIPCIÓN
												{    
				                
													xtype:'fieldsettable',
													collapsible: false,
													title: HreRem.i18n('fieldlabel.descripcion'),
													defaultType: 'textfieldbase',
													colspan:3,
													border:0,
													items :
														[
											     		   {
											                	xtype: 'textareafieldbase',
											                	bind:		'{trabajo.descripcion}',
											                	maxLength: 256
							                				}
					                					]
			                					}
											]
						           }
        				]
    			}
    	]
    	me.callParent();
    },
    
    resetWindow: function() {

    	var me = this,    	
    	form = me.down('formBase');     	

		form.setBindRecord(form.getModelInstance());
		form.reset();

		me.idProceso = null;
		me.getViewModel().set('idActivo', me.idActivo);
    	me.getViewModel().set('idAgrupacion', me.idAgrupacion);
		//PARA CARGAR EL GESTOR DEL ACTIVO AL ABRIR LA VENTANA, DENTRO DE LA FICHA DEL ACTIVO
    	me.lookupReference('gestorActivo').setValue(me.gestorActivo);


    }


});