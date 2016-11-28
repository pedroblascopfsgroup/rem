Ext.define('HreRem.view.activos.detalle.InfoLocalComercial', {
    extend: 'HreRem.view.common.FieldSetTable',
    xtype: 'infolocalcomercial',
    
    requires: [
               'HreRem.view.activos.detalle.DistribucionPlantasActivoList',
               'HreRem.view.activos.detalle.InstalacionesActivoInformacionComercial'
    ],
    
    initComponent: function () {

        var me = this;        
		me.items = [
						{ 	
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.longitud.fachada.calle.principal'),
			            	bind:		'{infoComercial.mtsFachadaPpal}',
							readOnly: true
						},
						{ 
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
							fieldLabel: HreRem.i18n('fieldlabel.longitud.fachada.calles.laterales'),
		                	bind:		'{infoComercial.mtsFachadaLat}',
							readOnly: true
		                },
		                { 
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.altura.libre'),
			            	bind:		'{infoComercial.mtsAlturaLibre}',
							readOnly: true
						},
						{
			        	    xtype:'fieldset',
			        	    layout: 'fit',
							flex: 1,
							colspan: 3,
							title: HreRem.i18n('title.distribucion.plantas'),
							items :
							[
								{
									xtype: 'distribucionplantasactivolist'
								} 
							]
						},
						{
			        	    xtype:'fieldset',				        	 
			        	    title: HreRem.i18n('title.otras.caracteristicas'),
							colspan: 1,
							items :
							[
				                { 
						        	xtype: 'container',
						        	layout: {
								        type: 'table',
						        		columns: 1,
						        		tableAttrs: {
								            style: { width: '25%' }
								        }
							        },
							 		items :
							 			[
											{
												 xtype: 'checkboxfieldbase',
												 fieldLabel: HreRem.i18n('fieldlabel.salida.humos'),
												 bind: '{infoComercial.existeSalidaHumos}',
												 readOnly: true
											 },
											 {
												 xtype: 'checkboxfieldbase',
												 fieldLabel: HreRem.i18n('fieldlabel.salida.emergencia'),
												 bind: '{infoComercial.existeSalidaEmergencias}',
												 readOnly: true
											 },
											 {
												 xtype: 'checkboxfieldbase',
												 fieldLabel: HreRem.i18n('fieldlabel.acceso.minusvalidos'),
												 bind: '{infoComercial.existeAccesoMinusvalidos}',
												 readOnly: true
											 },
											 {
												 xtype: 'checkboxfieldbase',
												 fieldLabel: HreRem.i18n('fieldlabel.otros'),
												 bind: '{infoComercial.existeOtrasCaracteristicas}',
												 readOnly: true
											 }
							 			 ]
								},
								{
									 xtype: 'textareafieldbase',
									 fieldLabel: HreRem.i18n('fieldlabel.otros.descripcion'),
									 maxWidth:	500,
							 		 minWidth:	300,
									 bind:		'{infoComercial.otrosOtrasCaracteristicas}'
								 }
							]
						},
						{
							xtype: 'container',
							colspan: 2,
							margin: '0 10 0 10',
					 		items :
					 			[
						 			{
						 				xtype: 		'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.uso.idoneo'),
					                	bind:		'{infoComercial.usuIdoneo}',
					                	flex:		1,
										readOnly: 	true
						 			},
						 			{ 
										xtype: 		'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.uso.anterior'),
					                	bind:		'{infoComercial.usuAnterior}',
					                	flex:		1,
										readOnly: 	true
					                },
					                { 
								 		xtype: 		'textareafieldbase',
								 		maxWidth:	800,
								 		minWidth:	600,
								 		fieldLabel: HreRem.i18n('fieldlabel.info.distribucion.interior'),
								 		flex:		2,
								 		height: 	120,
						            	bind:		'{infoComercial.infoDistribucionInterior}'
								   }
					 			]
						},
						{
							 xtype:'fieldset',
			        	    layout: 'fit',
							flex: 1,
							colspan: 3,
							title: HreRem.i18n('title.instalaciones'),
							items :
							[
								{
									xtype: 'instalacionesactivoinformacioncomercial',
									layout: {
								        type: 'table',
								        columns: 3,
								        trAttrs: {height: '30px', width: '100%'},
								        tdAttrs: {width: '33%'},
								        tableAttrs: {
								            style: {
								                width: '100%'
												}
								        }
									}
								} 
							]
						}
		];            
       
    	me.callParent();
    	
    }
    
});