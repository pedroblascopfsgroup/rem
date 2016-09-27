/**
 * Menu principal que extiende del componente Ext.list.Tree. Se sobreescribe
 * para desactivar la funcionalidad implementada sobre los eventos mouseleave y mouseover.
 * 
 * Para añadir elementos al menu principal, se debe modificar menuItems.
 * 
 */
 
Ext.define('HreRem.MenuPrincipal', {
    extend: 'Ext.list.Tree',
    xtype: 'menuprincipal',
    reference: 'menuPrincipal',
    itemId: 'menuPrincipal',
   	cls: 'app-menu',
    micro: true,
    ui: 'navigation',  
    
     /*
	 *  Es necesario importar las clases principales a las que se accedera desde el menu, aunque finalmente por permisos no se pueda acceder.
	 */
   requires: ['HreRem.view.dashboard.DashBoardMain', 'HreRem.view.agenda.AgendaMain', 'HreRem.view.activos.ActivosMain', 'HreRem.view.agrupaciones.AgrupacionesMain',
	'HreRem.view.trabajos.TrabajosMain', 'HreRem.view.masivo.MasivoMain', 'HreRem.view.agenda.AgendaAlertasMain', 'HreRem.view.agenda.AgendaAvisosMain',
	'HreRem.view.precios.PreciosMain', 'HreRem.view.publicacion.PublicacionMain', 'HreRem.view.comercial.ComercialMainMenu',
	'HreRem.view.configuracion.ConfiguracionMain', 'HreRem.view.administracion.AdministracionMainMenu'],
    
    viewModel: {
        type: 'mainviewport'
    },
    
    width: 60,
    expanderFirst: false,
    expanderOnly: false,
    listeners: {
        selectionchange: 'onMenuPrincipalSelectionChange'
    },
    
   	constructor: function(config) {
	        var me = this;
	        	      
	        me.callParent([config]);
	        if(!Ext.isEmpty(me.cls)) {
	        	me.element.addCls(me.cls);
        	}
	 }   

});

/**
 * Corrige bug que hace que el componente no añada el contenido del atributo cls
 */
Ext.list.TreeItem.override({	
	constructor: function (config) {
		
		var me = this;
        me.callParent([config]);

         if(!Ext.isEmpty(config.node.get("cls"))) {
	        me.element.addCls(config.node.get("cls"));
         }
    },
    updateFloated: function (floated, wasFloated) {
        var me = this;

        me.callParent([floated, wasFloated]);
        me.element.toggleCls(me.floatedCls, floated);
        if(me.floater) {
        	me.floater.addCls(me._node.get("cls"));
        }

        me.toolElement.toggleCls(me.floatedToolCls, floated);
    }


});

