
Ext.define('HreRem.view.activos.detalle.FotosActivo', {
    extend: 'Ext.panel.Panel',
    xtype: 'fotosactivo',  
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    flex: 1,
    layout: 
    	{
			type : 'vbox',
			align : 'stretch'
		},
		
    reference: 'fotosactivo',

    requires: ['HreRem.view.activos.detalle.FotosWebActivo','HreRem.view.activos.detalle.FotosTecnicasActivo'],
    
    defaults: {
        xtype: 'container',
        sytle: 'padding-left: 15px !important',
        defaultType: 'displayfield'
    },
	
    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.fotos'));      
        
        var items= [

			{				
			    xtype		: 'tabpanel',
			    flex 		: 3,
				cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
			    reference	: 'tabpanelfotosactivo',

			    /*listeners: {
			    	
		            beforetabchange: function (tabPanel, tabNext, tabCurrent) {
		            	
		            	if (tabCurrent != null)
		            	{
			            	if (tabPanel.down('button[itemId=botoneditar]').hidden == true)
			            	{	
			            		Ext.Msg.show({
			            			   title: HreRem.i18n('title.descartar.cambios'),
			            			   msg: HreRem.i18n('msg.desea.descartar'),
			            			   buttons: Ext.MessageBox.YESNO,
			            			   fn: function(buttonId) {
			            			        if (buttonId == 'yes') {
			            			        	var btn = tabPanel.down('button[itemId=botoncancelar]');
			            			        	Ext.callback(btn.handler, btn.scope, [btn, null], 0, btn);
			            			        	tabPanel.getLayout().setActiveItem(tabNext);
			            			        }
			            			   }
			        			});
			            		
			            		return false;
			            	}

			            	return true;
		            	}
		            	
		            }
		        },*/

			    layout: 'fit',
			   	/*tabBar: {
			        items: [
			        		{
			        			xtype: 'tbfill'
			        		},
			        		{
			        			extend	: 'Ext.button.Button',
			        			itemId: 'botoneditar',
			        		    handler	: 'onClickBotonEditar', 
			        		    iconCls: 'fa fa-pencil-square-o edit-button-color',
			        		    cls: 'x-btn-round-small',
			        		    tipoId: 'activo',
			        		    closable: false
			        		},
			        		{
			        			extend	: 'Ext.button.Button',
			        			itemId: 'botonguardar',
			        		    handler	: 'onClickBotonGuardar', 
			        		    iconCls: 'fa fa-check save-button-color',
			        		    cls: 'x-btn-round-small',
			        		    hidden: true,
			        		    tipoId: 'activo',
			        		    closable: false
			        		},
			        		{
			        			extend	: 'Ext.button.Button',
			        			itemId: 'botoncancelar',
			        		    handler	: 'onClickBotonCancelar', 
			        		    iconCls: 'fa fa-times cancel-button-color',
			        		    cls: 'x-btn-round-small',
			        		    hidden: true,
			        		    tipoId: 'activo',
			        		    closable: false
			        		}]
			    },*/
			    items: [
			    		
			    		{
			    			xtype: 'fotoswebactivo'
			    		},
			    		{
			    			xtype: 'fotostecnicasactivo'
			    		}
			    		
			    		
			     ]				
			}

    	];   	
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
     /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	    	
    	var me = this;    	
    	//me.down("cabeceraactivo").configCmp(data);

    },
	
	funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabFotos(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    } 
    
});