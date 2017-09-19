Ext.define('HreRem.view.trabajos.detalle.ActivosAgrupacionTrabajoList', {
	extend : 'HreRem.view.common.GridBase',
	xtype : 'activosagrupaciontrabajolist',
	requires : [ 'HreRem.view.common.CheckBoxModelBase',
			'HreRem.ux.plugin.PagingSelectionPersistence' ],
	bind : {
		store : '{activosAgrupacion}'
	},
	plugins : 'pagingselectpersist',

	initComponent : function() {

		var me = this;

		me.columns = [ {
			dataIndex : 'numActivo',
			text : HreRem.i18n('header.numero.activo.haya'),
			flex : 1
		}, {
			dataIndex : 'numFincaRegistral',
			text : HreRem.i18n('header.finca.registral'),
			flex : 1
		}, {
			dataIndex : 'tipoActivoDescripcion',
			text : HreRem.i18n('header.tipo'),
			flex : 1
		}, {
			dataIndex : 'subtipoActivoDescripcion',
			text : HreRem.i18n('header.subtipo'),
			flex : 1
		}, {
			dataIndex : 'situacionComercial',
			text : HreRem.i18n('header.situacion.comercial'),
			flex : 1
		}, {
			dataIndex : 'situacionPosesoria',
			text : HreRem.i18n('header.situacion.posesoria'),
			flex : 1
		} ];

		me.dockedItems = [ {
			xtype : 'pagingtoolbar',
			dock : 'bottom',
			displayInfo : true,
			bind : {
				store : '{activosAgrupacion}'
			},
			items : [ {
				xtype : 'tbfill'
			}, {
				xtype : 'displayfieldbase',
				itemId : 'displaySelection',
				fieldStyle : 'color:#0c364b; padding-top: 4px'
			} ]
		} ];

		me.selModel = Ext.create('HreRem.view.common.CheckBoxModelBase');

    	me.callParent();

    	me.getSelectionModel().on({
        	'selectionchange': function(sm,record,e) {
        		me.fireEvent('persistedsselectionchange', sm, record, e, me, me.getPersistedSelection());
        	},
        	
        	'selectall': function(sm) {
        		me.getPlugin('pagingselectpersist').selectAll();
        	},
        	   	
        	'deselectall': function(sm) {
        		me.getPlugin('pagingselectpersist').deselectAll();
        	}
        });
    },

    getPersistedSelection: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').getPersistedSelection();     	
    },

    deselectAll: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').deselectAll();     		
    },
    
    getActivoIDPersistedSelection: function() {
    	var me = this;
    	var arraySelection = me.getPlugin('pagingselectpersist').getPersistedSelection();
		var activoSelection = [];

		Ext.Array.each(arraySelection, function(rec) {
			activoSelection.push(rec.getData().idActivo);
        });

    	return activoSelection;
    }

});