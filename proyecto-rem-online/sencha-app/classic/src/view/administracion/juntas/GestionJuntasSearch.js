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
    	//me.buttons = [{ text: 'Buscar', handler: 'onClickProvisionesSearch' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
        //me.buttonAlign = 'left';
        
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
					        name: 'juntasFechaDesde',
					        formatter: 'date("d/m/Y")'				
					    },	
					    { 
					    	xtype:'datefieldbase',
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.juntas.fecha.hasta'),
					        name: 'juntasFechaHasta',
					        formatter: 'date("d/m/Y")'				
					        	
					    },
					    { 
					    	fieldLabel: HreRem.i18n('fieldlabel.agrupacion.juntas.numero.proveedor'),
					        name: 'numProveedor'
					    }
				 ]
        }

        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

