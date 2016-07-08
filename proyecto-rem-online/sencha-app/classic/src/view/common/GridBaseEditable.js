Ext.define('HreRem.view.common.GridBaseEditable', { 
    extend		: 'Ext.grid.Panel',
    xtype		: 'gridBaseEditable',
	cls	: 'panel-base shadow-panel',
	
	/**
	 * Para mostrar una botonera arriba con botones de añadir, editar, eliminar
	 * @type Boolean
	 */
	topBar: false,
	
	viewConfig:{
    	markDirty:false
	},

	initComponent: function() {
		
		var me = this;
		
		me.selModel = 'cellmodel';
		
		me.cellEditing = new Ext.grid.plugin.CellEditing({
            clicksToEdit: 2
        });
        
        Ext.apply(this, {
			plugins: [this.cellEditing]
			});			

	    me.listeners = {
        	edit: function(editor, context, eOpts) {
        		context.record.save({
                                params: {
                                    idActivo: this.up('{viewModel}').getViewModel().get('activo.id')
                                }
                            });

        	} 
    	};
		
		
		if(me.topBar) {
			
			me.tbar = {
	    		xtype: 'toolbar',
	    		dock: 'top',
	    		items: [
	    				{iconCls:'x-fa fa-plus', handler: 'onAddClick', scope: this }
	    				/*,
	    				{iconCls:'x-fa fa-edit', handler: 'onEditClick'},//text: 'Editar'},
	    				{iconCls:'x-fa fa-minus', handler: 'onDeleteClick'}//text: 'Eliminar'}*/
	    		]
    		}

		};
		
		me.callParent();	
		
	},
	
	onAddClick: function(btn){
    	
	
		var me = this;
	    // Create a model instance
        var rec = new HreRem.model.Catastro({
            /*common: '',
            light: 'Mostly Shady',
            price: 0,
            availDate: Ext.Date.clearTime(new Date()),
            indoor: false*/
        });

        me.getStore().insert(0, rec);
        me.cellEditing.startEditByPosition({
            row: 0,
            column: 0
        });
    }
});