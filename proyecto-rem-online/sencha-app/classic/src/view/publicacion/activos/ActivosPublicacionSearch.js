Ext.define('HreRem.view.publicacion.activos.ActivosPublicacionSearch', {
	extend: 'HreRem.view.common.FormBase',
    xtype: 'activospublicacionsearch',
    isSearchForm: true,
    cls: 'panel-base shadow-panel',

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.publicaciones.activos.search'));
        
        me.items = [
                    
			{
				xtype: 'panel',
				minHeight: 100,
				layout: 'column',
				cls: 'panel-busqueda-directa',
				collapsible: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield',
			        style: 'width: 25%'
			    },
			    items: [
			    
			    	{
						items: [
				       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.admision'),
					        	name: 'admision'
					        	
					        },
				       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.publicacion'),
					        	name: 'publicacion'
					        	
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.gestion'),
					        	name: 'gestion'
					        }
						]
			    	},
			    	{
			    		items: [
					       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.precios'),
					        	name: 'precio'
					        	
					        },
				       		{ 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.publicacionForzada'),
					        	name: 'publiForzada'
					        	
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.despublicacionForzada'),
					        	name: 'despubliForzada'
					        }
							]
			    	},
			    	{
			    		items: [
					       		{ 
				       			fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.numActivoHaya'),
				            	name: 'numActivo',
				            	labelWidth:	150,
					        	width: 		230
					        },
					        { 
					        	xtype: 'combo',
					        	fieldLabel: HreRem.i18n('combolabel.publicaciones.combo.activos.cartera'),
					        	name: 'cartera',
					        	bind: {
				            		store: '{comboEntidadPropietaria}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo'
					        },
					        { 
					        	xtype: 'checkboxfield',
					        	boxLabel: HreRem.i18n('boxlabel.publicaciones.activos.search.check.publiConPrecioConsultar'),
					        	name: 'precioConsultar'
					        }
							]
			    	},
			    	{
			    		items: [
					       		{ 
				       			xtype: 'combo',
					        	fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.tipoActivo'),
					        	name: 'tipoActivo',
					        	bind: {
				            		store: '{comboTipoActivo}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo'
					        },
					        {
				            	xtype: 'combo',
					        	fieldLabel: HreRem.i18n('fieldlabel.publicaciones.activos.search.subtipoActivo'),
					        	name: 'subtipoActivo',
					        	bind: {
				            		store: '{comboSubtipoActivo}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo'
					        }
							]
			    	}
			    ]
			}
                    
        ];
        
        me.callParent(); 
        
    }


});

