Ext.define('HreRem.view.trabajos.detalle.TrabajosDetalleCabecera', {
    extend: 'Ext.container.Container',
    xtype: 'trabajosdetallecabecera',
    requires: ['HreRem.view.common.ToolFieldSet'],
    layout: 'fit',
    initComponent: function () {
    
	    var me = this;
	    
	    me.menu = Ext.create("Ext.menu.Menu", {
	    	width: 150,
		    cls: 'menu-favoritos',
		    plain: true,
		    floating: true,
	    	items: [
	    		{
	    			text: HreRem.i18n('btn.cerrar.pestanya'),
	    			handler: 'onClickBotonCerrarPestanya'
	    		},
	    		{
	    			text: HreRem.i18n('btn.cerrar.todas'),
	    			handler: 'onClickBotonCerrarTodas'
	    		}
	    		
	    	]
	    	
	    });

	    
	    me.items= [	 
				    {
				    	
			    			xtype:'toolfieldset',
			    			height: 175,
			   				bind: {
			   		         title: 'TRABAJO {trabajo.numTrabajo} / TIPO {trabajo.tipoTrabajoDescripcion} - {trabajo.subtipoTrabajoDescripcion}'
			   		        },
			        		cls: 'fieldsetBase cabecera',
			        		border: false,
							collapsible: true,
							collapsed: false,
						    layout: {
						        type: 'hbox'
						    },
							tools: [
							
								{	xtype: 'tbfill'},
								{
									xtype: 'button',
									margin: '10 6 0 0',
									cls: 'boton-cabecera',
									iconCls: 'ico-refrescar',
									handler	: 'onClickBotonRefrescar',
									tooltip: HreRem.i18n('btn.refrescar')
						    	},
						    	{
				        			xtype: 'botonfavorito',
				        			margin: '10 6 0 0',
				        			cssFavorito: 'ico-pestana-trabajos',
				        			tipoId: 'trabajo'									
								},
								{
									xtype: 'button',
									margin: '10 6 0 0',
									cls: 'boton-cabecera',
									iconCls: 'x-fa fa-bars',
									arrowVisible: false,
			   						menuAlign: 'tr-br',								
							        menu:  me.menu
						    	}
						    ],
							items: [
						    			{		
						    				xtype:'container',
					                   		flex: 4,
					                   		maxWidth: 900,
											height: 120,
					                   		margin: '5 20 10 30 ',
											defaultType: 'displayfield',
											defaults: {
												labelWidth: 90},
											autoScroll: true,
											layout: {
											    type: 'table',
										        columns: 2,
										        trAttrs: {width: '100%', pading: 0},
										        tdAttrs: {width: '33%',  pading: 0},
										        tableAttrs: {
										            style: {
										                width: '100%'
														}
										        }
											},
											cls: 'cabecera-apartado cabecera-info',
											items: [
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.tipo'),
															cls: 'cabecera-info-field',
															bind:		'{trabajo.tipoTrabajoDescripcion}'
														},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.fecha.alta'),
									                   		cls: 'cabecera-info-field',
															bind:		'{trabajo.fechaSolicitud}',
															renderer: Ext.util.Format.dateRenderer('d/m/Y')
									                   	},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.subtipo'),
															cls: 'cabecera-info-field',
										                	bind:		'{trabajo.subtipoTrabajoDescripcion}'
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.estado.y.fecha'),
															cls: 'cabecera-info-field',
															bind:		'{trabajo.estadoDescripcionyFecha}'
														},		
										                {
									                   		fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
									                   		cls: 'cabecera-info-field',
															bind:		'{trabajo.cartera}'
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.gestor.activo'),
									                   		cls: 'cabecera-info-field',
															//bind:		'{trabajo.gestorActivo}'
									                   		bind:		'{trabajo.gestorActivoResponsable}'
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.propietario'),
									                   		cls: 'cabecera-info-field',
															bind:		'{trabajo.propietario}'
									                   	}, 
					                   					{
									                   		fieldLabel: HreRem.i18n('fieldlabel.proveedor'),
									                   		cls: 'cabecera-info-field',
															bind:		'{trabajo.nombreProveedor}'
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.nombre.ug'),
									                   		cls: 'cabecera-info-field',
									                   		hidden: true,
															bind:{
																value:'{trabajo.nombreUg}'
															}
									                   	},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.nombre.expediente.trabajo'),
															cls: 'cabecera-info-field',
															hidden: true,
															bind:{
																value:'{trabajo.nombreExpediente}'
															}
										                },
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.nombre.proyecto'),
									                   		cls: 'cabecera-info-field',
									                   		hidden: true,
									                   		bind:{
																value:'{trabajo.nombreProyecto}'
															}
															
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.usuario.ultima.edicion'),
									                   		cls: 'cabecera-info-field',
									                   		bind:{
																value:'{trabajo.responsableTrabajo}'
															}
															
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.refacturacion.trabajo'),
									                   		cls: 'cabecera-info-field',
									                   		bind:{
																value:'{trabajo.refacturacionTrabajoDescripcion}'
															}
															
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.calculo.margen.trabajo'),
									                   		cls: 'cabecera-info-field',
									                   		bind:{
																value:'{trabajo.tipoCalculoMargenDescripcion}'
															}
															
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.porcentaje.margen'),
									                   		cls: 'cabecera-info-field',
									                   		bind:{
																value:'{trabajo.porcentajeMargen}'
															}
															
									                   	},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.importe.margen'),
									                   		cls: 'cabecera-info-field',
									                   		bind:{
																value:'{trabajo.importeMargen}'
															}
															
									                   	}
									                  
											]
										},
										{
											xtype:'container',
											style: 'float: right;',
											maxWidth: 400,
											bind: {
										    		hidden: '{!avisos.descripcion}'
										    },
											autoScroll: true,
											defaultType: 'displayfield',
											cls: 'cabecera-apartado cabecera-avisos',
											padding: '10 30 0 30',
											flex: 2,
											height: 150,
											items: [
							                   	{
													cls: 'display-field-avisos',
													bind: 
														{
												    		value: '{avisos.descripcion}'
												        }
							                   	}

							                  ]
							            }					
								]
				    }
    ];   	

	me.callParent();
    
	},
    /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	
    	var me = this;
    	me.down('botonfavorito').setOpenId(data.get("id"));
    	
    }
});