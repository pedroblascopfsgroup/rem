Ext.define('HreRem.view.expedientes.GestionEconomicaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestioneconomicaexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'gestionEconomicaExpediente',
    scrollable	: 'y',
    

    initComponent: function () {
        var me = this;
		me.setTitle(HreRem.i18n('title.gestion.economica'));
        var items= [

			{
				
            	xtype: 'fieldset',
            	collapsible: true,
            	title:  HreRem.i18n('title.horonarios'),
            	items : [
            	
                	{
					    xtype		: 'gridBaseEditableRow',
					    reference: 'listadohoronarios',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeHoronarios}'
						},									
						
						columns: [
						   {
					            text: HreRem.i18n('fieldlabel.participacion'),
					            dataIndex: 'participacion',
					            flex: 1
						   },						   
						   {
						   		text: HreRem.i18n('fieldlabel.proveedor'),
					            dataIndex: 'proveedor',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.id'),
					            dataIndex: 'codigoId',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('header.tipo.calculo'),
					            dataIndex: 'tipoCalculo',
					            flex: 1,
					            editor: {
									xtype: 'combobox',	
									reference: 'tipoCalculoHonorario',
									store: new Ext.data.Store({
										model: 'HreRem.model.ComboBase',
										proxy: {
											type: 'uxproxy',
											remoteUrl: 'generic/getDiccionario',
											extraParams: {diccionario: 'tiposCalculo'}
										},
										autoLoad: true
									}),
									displayField: 'descripcion',
    								valueField: 'codigo',
    								listeners:{
					            		change: 'onHaCambiadoImporteCalculo'
					           		}
								}
						   },
						   {
						   		text: HreRem.i18n('header.importe.calculo'),
					            dataIndex: 'importeCalculo',
					            flex: 1,
					            editor: {
					            	xtype:'numberfield',
					            	reference: 'importeCalculoHonorario',
					            	listeners:{
					            		change: 'onHaCambiadoImporteCalculo'
					           		},
					           		maxValue: null
					           							            
					            }
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.honorarios'),
					            dataIndex: 'honorarios',
					            flex: 1,
					            editor: {
					            	editable: false,
					            	xtype:'textfield',
					            	reference: 'honorarios'
					            }
						   },
						    {
						   		text: HreRem.i18n('fieldlabel.observaciones'),
					            dataIndex: 'observaciones',
					            flex: 1,
					            editor: {
					            	xtype:'textarea',
					            	reference: 'observaciones'
					            }
						   }
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeHoronarios}'
					            }
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
		var listadoHonorarios = me.down("[reference=listadohoronarios]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoHonorarios.getStore().load();		
		
    }
});