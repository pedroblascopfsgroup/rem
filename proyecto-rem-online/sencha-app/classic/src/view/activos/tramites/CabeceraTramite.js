Ext.define('HreRem.view.activos.tramites.CabeceraTramite', {
    extend: 'Ext.container.Container',
    xtype: 'cabeceratramite',
    layout: 'fit',
    style: 'padding-top:10px',
    requires: ['HreRem.view.common.ToolFieldSet'],
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
			    			height: 165,
			   				bind: {
			   		         title: 'TRAMITE {tramite.idTramite} / TIPO {tramite.tipoTramite}'
			   		        },
			        		cls: 'fieldsetBase cabecera',
			        		style: 'padding-top:10px',
			        		border: false,
							collapsible: true,
							collapsed: false,
						    layout: {
						        type: 'hbox',
						        align: 'stretch'
						    },
						    tools: [

						    
						    	{	xtype: 'tbfill'},
						    	{
									xtype: 'button',
									cls: 'boton-cabecera',
									iconCls: 'ico-refrescar',
									handler	: 'onClickBotonRefrescar',
									tooltip: HreRem.i18n('btn.refrescar')
						    	},
								{
									xtype: 'button',
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
											height: 150,
											defaultType: 'displayfield',
											padding: '0 20 0 20',
											defaults: {
												style: 'padding-left: 15px;'},
											layout: {
										        type: 'hbox',
										        align: 'stretch'
										    },
											items: [												  	
								                   	{							                   		
								                   		xtype:'container',
								                   		//width: '100%',
														defaultType: 'displayfield',
														padding: '10 0 0 0',
														layout: {
															type : 'table',
															width: '100%',
															columns: 2,
															tdAttrs : {
																style : {
																	padding : '0 10 0 10'
																},
																width: 250
															}
									    				},	
														items: [
										                   	{
										                   		fieldLabel: HreRem.i18n('fieldlabel.numero.activo.agrupacion.haya'),
																bind:		'{tramite.numActivo}'
										                   	},
											                { 
																xtype: 'imagefield',
																fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
																cls: 'cabecera-info-field',
																width: 70,
											                	bind: {
											                		src: '{getSrcCartera}'
											                	}
											                },
											                { 
																fieldLabel: HreRem.i18n('fieldlabel.estado'),
																bind:		'{tramite.estado}'
															},
															{
																fieldLabel: HreRem.i18n('fieldlabel.subtipo.trabajo'),
																bind:		'{tramite.subtipoTrabajo}'
															}
														]
								                   	}
											]
						    			}
								]
				    }
    ];   	

	me.callParent();

	}
});