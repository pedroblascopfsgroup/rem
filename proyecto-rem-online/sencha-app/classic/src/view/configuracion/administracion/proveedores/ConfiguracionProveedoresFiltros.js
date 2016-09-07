Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresFiltros', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'configuracionproveedoresfiltros',
    reference	: 'configuracionProveedoresFiltros',
    scrollable: 'y',
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.proveedores.filtro"));  
        
        me.items= [ 
                   
			{
				xtype: 'panel',
				layout: 'column',
				cls: 'panel-busqueda-directa',
				title: HreRem.i18n('title.busqueda.directa'),
				collapsible: true,
				collapsed: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfieldbase',
			        style: 'width: 25%'
			    },
			    items: [   
				    	{
				    	defaults: {
				    		addUxReadOnlyEditFieldPlugin: false
				    	},
				    	items:[
					        { 
					        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo.haya'),
					        	name: 'numActivo'
					        },
					        { 
								xtype: 'comboboxfieldbase',
							    addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
					        	name: 'entidadPropietariaCodigo',
					        	bind: {
				            		store: '{comboEntidadPropietaria}'
				            	}
					        }
					    ]},
				    	{
				    	defaults: {
				    		addUxReadOnlyEditFieldPlugin: false
				    	},
				    	items:[
						        { 
						        	fieldLabel: HreRem.i18n('fieldlabel.poblacion'),
						        	name: 'localidadDescripcion'
				
						        },
						        { 
						        	xtype: 'comboboxfieldbase',
							    	addUxReadOnlyEditFieldPlugin: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						        	name: 'provinciaCodigo',
						        	bind: {
					            		store: '{comboFiltroProvincias}'
					            	}
						        }
						    ]},
					    {
					   	defaults: {
				    		addUxReadOnlyEditFieldPlugin: false
				    	},
					    items:[
					        {
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.origen'),
					        	name: 'tipoTituloActivoCodigo',
								//store: { type: 'diccionario', tipo: 'tiposTitulo'},
					        	bind: {
					            	store: '{comboTipoTitulo}'
					            },
								matchFieldWidth: false
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo'),
					        	name: 'subtipoActivoCodigo',
					        	bind: {
				            		store: '{comboFiltroSubtipoActivo}'
				            	},
					        	matchFieldWidth: false
				
					        }
					        
					    ]},
					    {	
					    defaults: {
				    		addUxReadOnlyEditFieldPlugin: false
				    	},
					    items:[
					        { 
					        	fieldLabel: HreRem.i18n('fieldlabel.finca.registral'),
					        	name: 'finca'
					        },
					        { 
					        	fieldLabel: HreRem.i18n('fieldlabel.referencia.catastral'),
					        	name: 'refCatastral'
					        }
					    ]}
				    ]
				},
//                {
//                	dataIndex: 'entidadPropietariaCodigo',
//		            text: HreRem.i18n('header.precios.automatica.activos.cartera.codigo'),
//		            flex: 1,
//		            hidden: true
//                },'HreRem.view.common.GridBase',
//		        {	        	
//		        	dataIndex: 'entidadPropietariaDescripcion',
//		            text: HreRem.i18n('header.cartera'),
//		            flex: 2	        	
//		        },
//		        {	        	
//		            dataIndex: 'numActivosPreciar',
//		            text: HreRem.i18n('header.precios.automatica.activos.preciar'),
//		            flex: 1,
//		            align: 'center'
//		        },
//		        {	        	
//		            dataIndex: 'numActivosRepreciar',
//		            text: HreRem.i18n('header.precios.automatica.activos.repreciar'),
//		            flex: 1,
//		            align: 'center'		        	
//		        },
//		        {	        	
//		        	dataIndex: 'numActivosDescuento',
//		            text: HreRem.i18n('header.precios.automatica.activos.descuento'),
//		            flex: 1,
//		            align: 'center',
//		            hidden: true
//		        }
        ];
        
        me.callParent(); 

        
    }


});

