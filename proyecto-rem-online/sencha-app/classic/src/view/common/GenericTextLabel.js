Ext.define('HreRem.view.common.GenericTextLabel', {
  extend: 'Ext.form.field.Text',
  alias: 'widget.generictextlabel',

  require: ['HreRem.ux.data.Proxy'],
  
  constructor: function(config) {

	  Ext.apply(this,config, {
				fieldLabel: config.fieldLabel,
				name: config.name,
				value: config.value,
				labelWidth: 180,
				width: '100%',
				editable: false
		});

    this.callParent();

  }

});
