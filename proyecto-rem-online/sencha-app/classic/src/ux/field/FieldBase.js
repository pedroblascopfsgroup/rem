/**
 * @class HreRem.ux.field.FieldBase
 * @author Jose Villel
 * Esta clase provee a los campos de formulario de configuraciones comunes.
 * Se utiliza añadiendo al componente:
 *   
 *   mixins: [
 *       'HreRem.ux.field.FieldBase'
 *   ],
 *   
 *   y llamando a la función initFieldBase en la iniciación del propio componente.
 */
Ext.define('HreRem.ux.field.FieldBase', {
    mixinId: 'fieldBase',
    
    requires: ['HreRem.ux.plugin.UxReadOnlyEditField'],
    
    defaultWidth: '100%',
    
    defaultMaxWidth: 400,
    
    /**
     * Poner a false en los fields que no se necesite edición (por ejemplo filtros)
     * @type Boolean
     */
    addUxReadOnlyEditFieldPlugin: true,

    initFieldBase: function() {
    	
    	var me = this;
    	
    	if(me.addUxReadOnlyEditFieldPlugin) {
    		me.addPlugin({ptype: 'UxReadOnlyEditField'});
    	}
	
		me.enforceMaxLength = true;
	
		me.msgTarget= 'side';
		
		if(Ext.isEmpty(me.width)) {
			me.setWidth(me.defaultWidth);
		}
		
		if(Ext.isEmpty(me.maxWidth)) {
			me.setMaxWidth(me.defaultMaxWidth);
		}
		
		/**
	     * Override de la función original para evitar que no publique los valores invalidos. El motivo es porque sino publicamos los valores inválidos, al hacer un reject
	     * del modelo este no considera como modificados los campos invalidos, y por lo tanto no los refresca.
	     * Publish the value of this field.
	     * @private
	     */
	    me.publishValue = function() {
	        var me = this;
	        if (me.rendered /*&& !me.getErrors().length*/) {
	            me.publishState('value', me.getValue());
	        }
	    }
    }
 

});
