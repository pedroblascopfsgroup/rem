Ext.define('HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevaofertadetalle',
    collapsed: false,
	scrollable	: 'y',
	cls:'',	  				
	recordName: "oferta",						
	recordClass: "HreRem.model.OfertaComercial",

    
	initComponent: function() {
    	
    	var me = this;
    	
    	
    	me.items = [
					{
						
								xtype:'fieldset',
								cls	: 'panel-base shadow-panel',
								layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 1,
							        trAttrs: {height: '45px', width: '100%'},
							        tdAttrs: {width: '100%'},
							        tableAttrs: {
							            style: {
							                width: '100%'
										}
							        }
								},
								defaultType: 'textfieldbase',
								collapsed: false,
									scrollable	: 'y',
								cls:'',	    				
				            	items: [
				            	    {
				            	    	name:		'id',
										bind:		'{oferta.idAgrupacion}',
										hidden:		true
				            	    },
									{
										xtype:      'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.importe'),
										flex: 		1,
										allowBlank: false,
										bind:		'{oferta.importeOferta}'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('header.oferta.tipoOferta'),
	    					        	itemId: 'comboTipoOferta',
	    					        	flex:	1,
	    					        	allowBlank: false,
	    					        	bind: {
	    				            		store: '{comboTipoOferta}',
	    				            		value: '{oferta.tipoOferta}'
	    				            	},
	    				            	displayField: 'descripcion',
	    	    						valueField: 'codigo',
	    	    						listeners: {
	    	    							change: function(combo, value) {
	    	    								var me = this;
	    	    								var form = combo.up('form');
	    	    								var checkTanteo = form.down('field[name=dederechotanteo]');
	    	    								checkTanteo.reset();
	    	    								checkTanteo.setDisabled(CONST.TIPOS_OFERTA['ALQUILER'] == value)
	    	    								
	    	    							}
	    	    						}
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.nombre.cliente'),
				            	    	name:		'nombreCliente',
										bind: {
											value: '{oferta.nombreCliente}',
											disabled: '{oferta.razonSocialCliente}'
										}
										
				            	    },
				            	    {
				            	    	fieldLabel: HreRem.i18n('fieldlabel.apellidos.cliente'),
				            	    	name:		'apellidosCliente',
										bind:		{
											value: '{oferta.apellidosCliente}',
											disabled: '{oferta.razonSocialCliente}'
										}
				            	    },
				            	    {
				            	    	fieldLabel: HreRem.i18n('fieldlabel.razonSocial.cliente'),
				            	    	name:		'razonSocialCliente',
										bind:		{
											value :'{oferta.razonSocialCliente}',
											disabled: '{oferta.nombreCliente}'
										}
				            	    },
				            	    {
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('fieldlabel.tipoDocumento'),
	    					        	itemId: 'comboTipoDocumento',
	    					        	allowBlank: false,
	    					        	flex:	1,
	    					        	bind: {
	    				            		store: '{comboTipoDocumento}',
	    				            		value: '{oferta.tipoDocumento}'
	    				            	},
	    				            	displayField: 'descripcion',
	    	    						valueField: 'codigo'
									},
				            	    {
				            	    	fieldLabel: HreRem.i18n('fieldlabel.documento.cliente'),
				            	    	name:		'numDocumentoCliente',
				            	    	allowBlank: false,
										bind:		'{oferta.numDocumentoCliente}'
				            	    },
				            	    {
				            	    	xtype: 		'checkboxfieldbase',
				            	    	fieldLabel:	HreRem.i18n('fieldlabel.dederechotanteo'),
				            	    	name:		'dederechotanteo',
				            	    	allowBlank:	false,
				            	    	bind:		'{oferta.deDerechoTanteo}',
							        	inputValue: true
				            	    }
									

				            	]
		    			   
		    		
				}
    	];
    	
    	me.callParent();
    	//me.setTitle(HreRem.i18n('title.nueva.oferta'));
    }
    
});