Ext.define('HreRem.view.activos.detalle.InfoEdificioCompleto', {
    extend: 'Ext.container.Container',
    xtype: 'infoedificiocompleto',

    initComponent: function () {

        var me = this;     
        
		me.items = [
		{
			xtype:			'fieldset',
			collapsible:	true,
			title:HreRem.i18n('title.edificio.colectivo'),
			layout: {
				type: 	'vbox',
				align: 	'stretch'
			},
			defaultType: 'textfieldbase',
			items :
			[
			 	{   
					xtype: 	'container',
					layout: {
						type: 'hbox',
		        	    align: 'stretch'
		        	},
					items :
					[
						{   
							xtype: 'container',
							width: '33%',
							margin: '0 10 0 10',
							layout: {
								type: 'vbox',
							    align: 'stretch'
							},
							items :
							[
					 			{
					 				xtype: 		'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo.edificio'),
						        	bind: {
					            		store: 	'{comboSubtipoActivo}',
					            		value: 	'{activo.subtipoActivoCodigo}'
					            	},
					            	readOnly: 	true
					 			},
					 			{ 
					 				xtype: 		'comboboxfieldbase',
									editable: 	false,
									readOnly: 	true,
									fieldLabel: HreRem.i18n('fieldlabel.divisible'),
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.edificioDivisible}'		            		
									}
					            }
				 			]
						},
						{
							xtype: 'container',
							width: '66%',
							margin: '0 10 0 10',
							layout: {
				        	      type: 'vbox',
				        	      align: 'stretch'
				        	},
							items :
								[
						            { 
								 		xtype: 		'textareafieldbase',
								 		maxWidth:	1200,
								 		fieldLabel: HreRem.i18n('title.otras.caracteristicas'),
								 		flex:		2,
								 		height: 	80,
						            	bind:		'{infoComercial.edificioOtrasCaracteristicas}'
								   }
								]
						}
			 		]
				},	
				{
	        	    xtype:		'fieldset',
	        	    layout: 	'fit',
					flex: 		1,
					colspan: 	3,
					title: 		HreRem.i18n('title.distribucion.plantas'),
					items :
						[
							{
								xtype: 'distribucionplantasactivolist'
							} 
						]
				},		
				{//Descripcion edificio
	        	    xtype:		'fieldset',
	        	    layout: 	'fit',
					flex: 		1,
					colspan: 	3,
					title: 		HreRem.i18n('fieldlabel.descripcion.edificio'),
					items :
						[
							{ 
						 		xtype: 		'textareafieldbase',
						 		maxWidth:	1600,
						 		flex:		2,
						 		height: 	120,
				            	bind:		'{infoComercial.ediDescripcion}'
						   }
						]
				},
				{   
					xtype: 		'container',
					margin: '0 10 0 10',
					layout: {
						type: 	'hbox',
		        	    align: 	'stretch'
		        	},
					items :
					[
						{
							xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.interior'),
							labelAlign: 'top',
							height: 	120,
							width: 		'33%',
							maxWidth:	600,
							margin: 	'0 10 10 0',
			            	bind:		'{infoComercial.edificioDescPlantas}'
						},
						{
							xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entorno.comunicaciones'),
							labelAlign: 'top',
							height: 	120,
							width: 		'33%',
							maxWidth:	600,
							margin: 	'0 10 10 0',
			            	bind:		'{infoComercial.entornoComunicaciones}'
						},
						{
							xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entorno.infraestructuras'),
							labelAlign: 'top',
							height: 	120,
							width: 		'33%',
							maxWidth:	600,
							margin: 	'0 10 10 0',
			            	bind:		'{infoComercial.entornoInfraestructuras}'
						}
					]
				}

			]     
    	}			
	];            
   
	me.callParent();
    	
    }
    
});