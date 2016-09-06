Ext.define('HreRem.view.expedientes.CompradoresExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'compradoresexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'compradoresexpedienteref',
    scrollable	: 'y',
    controller: 'expedientedetalle',
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.compradores.pbc'));
        var items= [

			{   
				xtype: 'fieldset',
            	title:  HreRem.i18n('title.compradores'),
            	items : [
                	{
					    xtype		: 'gridBase',
					    reference: 'listadoCompradores',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeCompradoresExpediente}'
						},									
						listeners : {
					    	rowdblclick: 'onCompradoresListDobleClick'	
					    },
					    
						columns: [
						   {    text: HreRem.i18n('header.id.cliente'),
					        	dataIndex: 'id',
					        	flex: 1
					       },
						   {
								text: HreRem.i18n('header.nombre.razon.social'),
								dataIndex: 'nombreComprador',
								flex: 1
						   },
						   {
						   		text: HreRem.i18n('header.numero.documento'),
					            dataIndex: 'numDocumentoComprador',
					            flex: 1
						   },						   
						   {
						   		text: HreRem.i18n('header.representante'),
					            dataIndex: 'nombreRepresentante',
					            flex: 1						   
						   },
						   {    text: HreRem.i18n('header.numero.documento'),
					        	dataIndex: 'numDocumentoRepresentante',
					        	flex: 1
					       },
						   {
								text: HreRem.i18n('header.procentaje.compra'),
								dataIndex: 'porcentajeCompra',
								flex: 1
						   },
						   {
						   		text: HreRem.i18n('header.telefono'),
					            dataIndex: 'telefono',
					            flex: 1
						   },						   
						   {
						   		text: HreRem.i18n('header.email'),
					            dataIndex: 'email',
					            flex: 1						   
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
					    ]
					}
            	]
			},
			{
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.estado.pbc.comprador'),
				items :
					[
		               /* {
		                	fieldLabel:  HreRem.i18n('fieldlabel...'),
		                	bind:		'{comprador.responsable}'

		                },
		                { 
							xtype: 'comboboxfieldbase',
							reference: 'comboEstadoPBC',
		                	fieldLabel:  HreRem.i18n('fieldlabel....'),
				        	bind: {
			            		store: '{comboEstadoPBC}',
			            		value: '{comprador.estadoPbc}'
			            	}
				        }*/     
		        ]
            },
            {
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.pbc'),
				items :
					[
		               /* {
		                	fieldLabel:  HreRem.i18n('fieldlabel...'),
		                	bind:		'{comprador.responsable}'

		                },
		                { 
							xtype: 'comboboxfieldbase',
							reference: 'comboEstadoPBC',
		                	fieldLabel:  HreRem.i18n('fieldlabel....'),
				        	bind: {
			            		store: '{comboEstadoPBC}',
			            		value: '{comprador.estadoPbc}'
			            	}
				        }*/     
		        ]
            },
            {
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.politica.corporativa'),
				items :
					[
		               /* {
		                	fieldLabel:  HreRem.i18n('fieldlabel...'),
		                	bind:		'{comprador.responsable}'

		                },
		                { 
							xtype: 'comboboxfieldbase',
							reference: 'comboEstadoPBC',
		                	fieldLabel:  HreRem.i18n('fieldlabel....'),
				        	bind: {
			            		store: '{comboEstadoPBC}',
			            		value: '{comprador.estadoPbc}'
			            	}
				        }*/     
		        ]
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		var listadoCompradores = me.down("[reference=listadoCompradores]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoCompradores.getStore().load();
    }
    
    
});