/**
 * @author Jose Villel
 * Modelo de selección que extiende de Ext.selection.CheckboxModel y que añade los eventos
 * selectall y deselectall. 
 *
 */
Ext.define('HreRem.view.common.CheckBoxModelBase', {
    alias: 'checkboxmodelbase',
    extend: 'Ext.selection.CheckboxModel',
    
    showHeaderCheckbox: true,
  
      /**
     * Toggle between selecting all and deselecting all when clicking on
     * a checkbox header.
     * Lanza los eventos selectall y deselectall en función de la operación a realizar.
     */
    onHeaderClick: function(headerCt, header, e) {
        var me = this,
            isChecked;

        if (header === me.column && me.mode !== 'SINGLE') {
            e.stopEvent();
            isChecked = header.el.hasCls(Ext.baseCSSPrefix + 'grid-hd-checker-on');

            if (isChecked) {
                me.deselectAll();
                me.fireEvent('deselectall', me);
            } else {
                me.selectAll();
                me.fireEvent('selectall', me);
            }
        }
    }
});
