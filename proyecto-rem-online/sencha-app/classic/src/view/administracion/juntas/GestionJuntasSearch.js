Ext.define('HreRem.view.administracion.juntas.GestionJuntasSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'gestionjuntassearch',
    isSearchFormJuntas: true,
    collapsible: true,
    collapsed: false, 
    layout: 'column',
	defaults: {
        xtype: 'fieldsettable',
        columnWidth: 1,
        cls: 'fieldsetCabecera'
    },    

    initComponent: function () {
    	
        var me = this;
        me.setTitle(HreRem.i18n("title.agrupacion.filtro.juntas"));
        me.removeCls('shadow-panel');    	
        
        var items = [
        	
        {

        		defaultType: 'textfieldbase',
	    		defaults: {							        
					addUxReadOnlyEditFieldPlugin: false
				},				
			    items: [
		
						{
							fieldLabel: HreRem.i18n('fieldlabel.agrupacion.juntas.numero.activo'),
						    name: 'numActivo'       	
						},												    							
					    { 
					    	xtype:'datefieldbase',
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.juntas.fecha.desde'),
					        name: 'fechaDesde',
					        formatter: 'date("d/m/Y")',
					        listeners : {
					            	change: function (a, b) {
					            		//Eliminar la fechaHasta e instaurar
					            		//como minValue a su campo el valor de fechaDesde
					            		var me = this,
					            		fechaHasta = me.up('form').down('[name=fechaHasta]');
					            		fechaHasta.reset();
					            		fechaHasta.setMinValue(me.getValue());
					                }
				            	}
					    },	
					    { 
					    	xtype:'datefieldbase',
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.juntas.fecha.hasta'),
					        name: 'fechaHasta',
					        formatter: 'date("d/m/Y")'				
					        	
					    },
					    { 
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.juntas.numero.proveedor'),
					        name: 'codProveedor'
					    }
				 ]
        }

        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

