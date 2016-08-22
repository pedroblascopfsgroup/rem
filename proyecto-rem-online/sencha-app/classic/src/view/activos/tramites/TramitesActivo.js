Ext.define('HreRem.view.activos.tramites.TramitesActivo', {
    extend: 'Ext.panel.Panel',
    xtype: 'tramitesactivo',  
    cls	: 'panel-base shadow-panel',
    layout: 'fit',
    requires: ['Ext.plugin.LazyItems'],
    initComponent: function() {

    	var me = this;
        me.setTitle(HreRem.i18n('title.tramites.tareas'));
        
    	var items=[
    	          {xtype: 'gridBase',
    	           bind: {
    	           	store: '{storeTramites}'
    	           },
    	           listeners:{
    	        	   rowdblclick: 'onTramitesListDobleClick'
    	           },
    	           reference: 'listadoTramites',
    	           columns: [
    	                     {
    	                    	 text: HreRem.i18n("header.codigo.tramite"),
    	                    	 flex: 1,
    	                    	 dataIndex: 'idTramite',
    	                    	 getSortParam: function() {
    	                    	 	return 'id';
    	                    	 }
    	                     },
    	                     {
    	                    	 text: 'Activo',
    	                    	 flex: 1,
    	                    	 dataIndex: 'idActivo',
    	                    	 hidden: true,
    	                    	 getSortParam: function() {
    	                    	 	return 'activo';
    	                    	 }
    	                     },
    	                     {
    	                    	 text: 'Tipo Trámite',
    	                    	 flex: 2,
    	                    	 dataIndex: 'tipoTramite'
    	                     },
    	                     {
    	                    	 text: 'Subtipo de trabajo',
    	                    	 flex: 1,
    	                    	 dataIndex: 'subtipoTrabajo'
    	                     },
    	                     {
    	                    	 text: 'Estado',
    	                    	 flex: 1,
    	                    	 dataIndex: 'estado',
    	                    	  getSortParam: function() {
    	                    	 	return 'estadoTramite';
    	                    	 }
    	                     },
    	                     {
    	                     	text: 'Fecha de inicio',
    	                     	flex: 1,
    	                    	dataIndex: 'fechaInicio'
//    	                    		,
//    	                    	formatter: 'date("d/m/Y")'	
    	                     },
    	                     {
    	                     	text: 'Fecha de finalización',
    	                     	flex: 1,
    	                    	dataIndex: 'fechaFinalizacion'
//    	                    		,
//    	                    	formatter: 'date("d/m/Y")'	
    	                     }
    	                     ]}
    	          ];
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	          
    	me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeTramites}'
		            }
		        }
		    ];
		    
    	me.callParent();
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});