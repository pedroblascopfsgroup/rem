Ext.define('HreRem.view.common.ItemSelectorBase', { 
    extend : 'Ext.ux.form.ItemSelector',
    xtype : 'itemselectorbase',
	cls	: 'itemselectorbase',
	labelAlign: 'top',
	height: 150,
	maxHeight: 150,
	width: 380,
	maxWidth: 380,
	requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
	
	// Campos del store para obtener los recursos.
	displayField: 'descripcion',
    valueField: 'codigo',
    
    // Posicion del mensaje de error. Por defecto en el lado derecho (seleccionado).
    msgTarget: 'side',
    
    // Indica si se muestran solo los botones de anyadir y remover. Por defecto True.
    justAddRemoveNavButtons: true,
    addRemovebuttons: ['add', 'remove'],    
    
    initComponent: function() {
        var me = this;
        
        // Nombre de las etiquetas de los paneles de seleccion y seleccionado.
        me.fromTitle = HreRem.i18n('itemSelector.label.available');
        me.toTitle = HreRem.i18n('itemSelector.label.selected');
        
        // Labels para los tooltip de los botones.
        me.buttonsText = {
            top: HreRem.i18n('itemSelector.btn.top.tooltip'),
            up: HreRem.i18n('itemSelector.btn.up.tooltip'),
            add: HreRem.i18n('itemSelector.btn.add.tooltip'),
            remove: HreRem.i18n('itemSelector.btn.remove.tooltip'),
            down: HreRem.i18n('itemSelector.btn.down.tooltip'),
            bottom: HreRem.i18n('itemSelector.btn.bottom.tooltip')
        };
        me.initFieldBase();
        me.callParent();
    },
    
    /**
     * Override del metodo para obtener los botones del itemselector.
     * Adaptado para mostrar con permiso de la variable @justAddRemoveNavButtons
     * los botones de añadir elemento y remover elemento.
     */
    createButtons: function() {
        var me = this,
            buttons = [];

        if (!me.hideNavIcons) {
        	if(!me.justAddRemoveNavButtons){
	            Ext.Array.forEach(me.buttons, function(name) {
	                buttons.push({
	                    xtype: 'button',
	                    ui: 'default',
	                    tooltip: me.buttonsText[name],
	                    ariaLabel: me.buttonsText[name],
	                    handler: me['on' + Ext.String.capitalize(name) + 'BtnClick'],
	                    cls: Ext.baseCSSPrefix + 'form-itemselector-btn',
	                    iconCls: Ext.baseCSSPrefix + 'form-itemselector-' + name,
	                    navBtn: true,
	                    scope: me,
	                    margin: '4 0 0 0'
	                });
	            });
        	} else {
        		Ext.Array.forEach(me.addRemovebuttons, function(name) {
	                buttons.push({
	                    xtype: 'button',
	                    ui: 'default',
	                    tooltip: me.buttonsText[name],
	                    ariaLabel: me.buttonsText[name],
	                    handler: me['on' + Ext.String.capitalize(name) + 'BtnClick'],
	                    cls: Ext.baseCSSPrefix + 'form-itemselector-btn',
	                    iconCls: Ext.baseCSSPrefix + 'form-itemselector-' + name,
	                    navBtn: true,
	                    scope: me,
	                    margin: '4 0 0 0'
	                });
	            });
        	}
        }
        return buttons;
    }
});