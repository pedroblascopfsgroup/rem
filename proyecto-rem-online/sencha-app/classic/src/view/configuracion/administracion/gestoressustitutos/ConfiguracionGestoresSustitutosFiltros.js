Ext.define('HreRem.view.configuracion.administracion.gestoressustitutos.ConfiguracionGestoresSustitutosFiltros', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'configuraciongestoressustitutosfiltros',
    reference: 'configuracionGestoresSustitutosFiltros',
    isSearchGestoresSustitutosForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,  

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.configuracion.gestoressustitutos.filtro'));
	    me.items= [
	         {
	        	 xtype: 'panel',
	 				minHeight: 50,
	    			layout: 'column',
	    			cls: 'panel-busqueda-directa',
	    			collapsible: false,	    			
				    defaults: {
				        layout: 'form',
				        columnWidth: .5,
				        xtype: 'container',
				        defaultType: 'textfield'				        
				    },
				items: [
					{ 
						xtype: 'comboboxsearchfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.gestoressustitutos.gestorasustituir'),						
						name: 'usernameOrigen',						
						bind: {
							store: '{comboUsuariosGestorSustituto}'
						}						
					},
					{ 
						xtype: 'comboboxsearchfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.gestoressustitutos.gestorsustituto'),
						name: 'usernameSustituto',
						bind: {
							store: '{comboUsuariosGestorSustituto}'
						}
					}
				]
    		}
	    ];
	    
	    me.callParent();
	}
});