Ext.define('HreRem.view.gastos.SeleccionTasacionesGastoSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'selecciontasacionesgastosearch',
    collapsible: true,
    collapsed: false,       
    layout: 'column',
	defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'

    },
	    		

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro'));
    	me.removeCls('shadow-panel');
  		
    	me.buttonAlign = 'left';
    	me.buttons = [{ reference: 'searchButton', text: 'Buscar', handler: 'onSearchClickTasaciones', disabled: true },{ text: 'Limpiar', handler: 'onCleanFiltersClickTasaciones'}];
    	
	    me.items= [
	    
				    {
				    		items: [
					        				{ 
								            	fieldLabel: HreRem.i18n('fieldlabel.listado.tasacion.id'),
								            	reference: 'idTasacion',
								            	name: 'idTasacion',
								            	style: 'width: 33%',
			    								listeners: {
			    									change: 'activateBotonBuscarTasacion'
			    								}
								            },
								            {
										 		fieldLabel: HreRem.i18n('header.listado.tasacion.externo.bbva'),
										 		name: 'idTasacionExt',
								            	reference: 'idTasacionExt',
                                                listeners: {
                                                    change: 'activateBotonBuscarTasacion'
                                                }
											}
							]
				    },
				    {
				    		items: [
				    						
								            {
									        	fieldLabel: HreRem.i18n('fieldlabel.id.activo.haya'),
									        	reference: 'numActivo',
									        	name: 'numActivo',
					    						style: 'width: 33%',
                                                listeners: {
                                                    change: 'activateBotonBuscarTasacion'
                                                }
										    },
										    {
										 		fieldLabel: HreRem.i18n('fieldlabel.codigo.firma.tasacion'),
										 		name: 'codigoFirmaTasacion',
									        	reference: 'codigoFirmaTasacion',
                                                listeners: {
                                                    change: 'activateBotonBuscarTasacion'
                                                }
											}
				    		]
				    },
				    {
				    		items: [	
				    						{
                                                xtype:'datefield',
                                                fieldLabel: HreRem.i18n('fieldlabel.fecha.rec.tasacion'),
                                                name: 'fechaRecepcionTasacion',
                                                reference: 'fechaRecepcionTasacion',
                                                formatter: 'date("d/m/Y")',
                                                listeners: {
                                                    change: 'activateBotonBuscarTasacion'
                                                }
                                            }
]
				    		
				    }		        
            
	    ];
	   	
	    me.callParent();
	}
});