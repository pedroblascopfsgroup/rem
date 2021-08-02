Ext.define('HreRem.view.trabajos.detalle.listaActivosAgrupacionGrid', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'listaactivosagrupaciongrid',
    requires: ['HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
    bind: {
        store: '{listaActivosAgrupacion}'
    },
    loadAfterBind: true,    
    plugins: 'pagingselectpersist',
    
    
    initComponent: function () {
        
        var me = this;       

        me.columns= [
				{
					dataIndex: 'numActivoHaya',
					text: HreRem.i18n('header.numero.activo.haya'),
					flex: 1										
				},
				{
					dataIndex: 'numFincaRegistral',
					text: HreRem.i18n('header.finca.registral'),
					flex: 1										
				},
				{
				     dataIndex: 'tipoActivo',
				     text: HreRem.i18n('header.tipo'),
				     flex: 1
				},
				{
				     dataIndex: 'subtipoActivo',
				     text: HreRem.i18n('header.subtipo'),
					 flex: 1													            
				},
				{
					dataIndex: 'cartera',
					text: HreRem.i18n('header.cartera'),
					flex: 1	 	
				},
				{
				    dataIndex: 'situacionComercial',
				    text: HreRem.i18n('header.situacion.comercial'),
				    flex: 1
				},
				{
				    dataIndex: 'situacionPosesoria',
				    text: HreRem.i18n('header.situacion.posesoria'),
				    flex: 1													            
				},
		        {
		        	dataIndex: 'activoEnPropuestaEnTramitacion',
		        	text: HreRem.i18n("header.incluido.en.propuesta.tramite"),
		        	hidden: true,
		        	renderer: Utils.rendererBooleanToSiNo,
		        	flex: 1
		        },{
		        	dataIndex: 'activoTramite',
		        	text: HreRem.i18n("header.en.tramite"),
		        	hidden: false,
		        	renderer: Utils.rendererBooleanToSiNo,
		        	flex: 1
		        }
        ];
        
        
        me.dockedItems =  [
		       				{
								xtype: 'pagingtoolbar',
							    dock: 'bottom',
							    inputItemWidth: 50,
								displayInfo: true,
								bind: {
								       store: '{listaActivosAgrupacion}'
								      }
		       				}
		       			];

    	
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
    
    getActivoIDPersistedSelection: function() {
    	var me = this;
    	var arraySelection = me.getPlugin('pagingselectpersist').getPersistedSelection();
		var idAct = [];
		Ext.Array.each(arraySelection, function(rec) {
			idAct.push(rec.getData().idActivo);
        });

    	return idAct;
    }    
});

