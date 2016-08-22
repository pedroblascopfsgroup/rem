Ext.define('Ext.overrides.grid.column.Column', {
	override: 'Ext.grid.column.Column',

	/**
	 * Override para obligar a todas las columnas a que tengan por defecto
	 * como tooltip el texto de la columna.
	 * @return {}
	 */

    initRenderData: function() {
        var me = this,
            tipMarkup = '',
            tip = '',
            text = me.text,
            attr = me.tooltipType === 'qtip' ? 'data-qtip' : 'title';
            
        if (Ext.isEmpty(me.tooltip) && !Ext.isEmpty(me.text) && me.text != '&#160;') {
        	me.tooltip = me.text;
        }  
        
        tip = me.tooltip
 
        if (!Ext.isEmpty(tip)) {
            tipMarkup = attr + '="' + tip + '" ';
        }
 
        return Ext.applyIf(me.callParent(arguments), {
            text: text,
            empty: text === '&#160;' || text === ' ' || text === '',
            menuDisabled: me.menuDisabled,
            tipMarkup: tipMarkup,
            triggerStyle: this.getTriggerVisible() ? 'display:block' : ''
        });
    }
    
});