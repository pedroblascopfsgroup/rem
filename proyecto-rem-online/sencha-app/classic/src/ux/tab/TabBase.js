/**
 * @class HreRem.ux.tab.TabBase
 * @author Jose Villel
 * Esta clase provee a los tabs, configuraciones y funcionalidades comunes.
 * Se utiliza añadiendo al componente:
 *   
 *   mixins: [
 *       'HreRem.ux.tab.TabBase'
 *   ],
 *   
 *   y llamando a la función initTabBase en la iniciación del propio componente.
 */
Ext.define('HreRem.ux.tab.TabBase', {
    mixinId: 'tabBase',
          
    /**
     * Poner a true en los tabs que no necesiten edición
     * @type Boolean
     */
    ocultarBotonesEdicion: false,

    initTabBase: function() {
    	
    	var me = this;
    	
    },
    
    getOcultarBotonesEdicion: function() {
    	var me = this;
    	return me.ocultarBotonesEdicion;
    },
    	
    setOcultarBotonesEdicion: function (ocultarBotonesEdicion) {
    	var me = this;
    	me.ocultarBotonesEdicion = ocultarBotonesEdicion;
    	
    	var tabPanel = me.up('tabpanel');
    	
    	if(!Ext.isEmpty(tabPanel) && Ext.isFunction(tabPanel.evaluarBotonesEdicion)){
    		tabPanel.evaluarBotonesEdicion(me);
    	}
   	}
 

});