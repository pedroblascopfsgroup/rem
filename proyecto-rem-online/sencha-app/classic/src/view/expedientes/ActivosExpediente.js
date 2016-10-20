Ext.define('HreRem.view.expedientes.ActivosExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'activosexpediente', 
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'activosexpedienteref',
	layout: 'fit',

    initComponent: function () {

        var me = this;        
        me.setTitle(HreRem.i18n('title.publicaciones.activos.grid'));		         
        var items= [

			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal : 'expediente.id',
			    reference: 'listadoactivos',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeActivosExpediente}'
				},
				
				features: [{
				            id: 'summary',
				            ftype: 'summary',
				            hideGroupedHeader: true,
				            enableGroupingMenu: false,
				            dock: 'bottom'
				}],
				columns: [
				   {    xtype: 'actioncolumn',
	    			text: HreRem.i18n('fieldlabel.numero.activo'),
		        	dataIndex: 'numActivo',
			        items: [{
			            tooltip: HreRem.i18n('fieldlabel.ver.activo'),
			            getClass: function(v, metadata, record ) {
			            	return "app-list-ico ico-ver-activov2";
			            				            	
			            },
			            handler: 'onEnlaceActivosClick'
			        }],
			        renderer: function(value, metadata, record) {
			        		return '<div style="float:right; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        	
			        },
		            flex     : 1,            
		            align: 'left',
		            menuDisabled: true,
		            hideable: false
			       },
				   {
			            text: HreRem.i18n("fieldlabel.subtipo.activo"),
			            dataIndex: 'subtipoActivo',
			            flex:1
			            
			       },
			       {
			            text: HreRem.i18n("header.importe.participacion"),
			            dataIndex: 'importeParticipacion',
			            flex:1
			       },
			       {   
			       		text: HreRem.i18n("header.porcentaje.participacion"),
			       	    dataIndex: 'porcentajeParticipacion',
			       	    editor: 'textfield',
			       		flex:1,
			       		renderer: function(value) {
			            	return Ext.util.Format.number(value, '0.00%');
			            },
			       		summaryType: 'sum',
			            summaryRenderer: function(value, summaryData, dataIndex) {
			            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value + "%";
			            	var style = "" 
			            	if(value != 100) {
			            		msg = HreRem.i18n("fieldlabel.participacion.total.error")	
			            		style = "style= 'color: red'" 
			            	}			            	
			            	return "<span "+style+ ">"+msg+"</span>"
			            }
			       },
			       {   
			       		text: HreRem.i18n("header.precio.minimo.autorizado"),
			       	    dataIndex: 'precioMinimo',
			       		flex:1
			       },
			       {   
			       		text: HreRem.i18n("header.precio.aprobado.venta"),
			       	    dataIndex: 'precioAprobadoVenta',
			       		flex:1
			       }
			       	        
			    ],
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeActivosExpediente}'
			            }
			        }
			    ]
			    
			}
            
            
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
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