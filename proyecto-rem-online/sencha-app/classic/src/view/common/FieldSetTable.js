Ext.define('HreRem.view.common.FieldSetTable', { 
    extend		: 'Ext.form.FieldSet',
    xtype		: 'fieldsettable',
    
    collapsible: true,
    collapsed: false,
    layout: {
        type: 'table',
        // The total column count must be specified here
        columns: 3,
        tdAttrs: {width: '33%'},
        tableAttrs: {
            style: {
                width: '100%'
				}
        }
	}

});