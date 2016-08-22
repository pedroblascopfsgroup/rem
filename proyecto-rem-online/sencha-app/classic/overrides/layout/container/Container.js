/**
 * Override que soluciona el bug por el que aparece en consola del navegador el siguiente
 * warning: [W] targetCls is missing. This may mean that getTargetEl() is being overridden but no
 * sin ser necesario.
 */
Ext.define('Ext.overrides.layout.container.Container', {
  override: 'Ext.layout.container.Container',

  notifyOwner: function() {
    this.owner.afterLayout(this);
  }
});