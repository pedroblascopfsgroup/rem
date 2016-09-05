Ext.define('HreRem.view.comercial.visitas.VisitasComercialList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'visitascomerciallist',
    bind: {
        store: '{visitasComercial}'
    },
    loadAfterBind: false,
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.lista.visitas'));
        
        me.columns= [
        
		        {	        	
		            dataIndex: 'numVisitaRem',
		            text: HreRem.i18n('header.numero.visita'),
		            flex: 1		        	
		        },
		       
		        {
	    			xtype: 'actioncolumn',
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
//		            menuDisabled: true,
		            hideable: false
		        },
		        {
		            dataIndex: 'fechaSolicitud',
		            text: HreRem.i18n('header.fecha.solicitud'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'nombre',
		            text: HreRem.i18n('header.nombre'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'numDocumento',
		            text: HreRem.i18n('header.numero.documeto'),
		            flex: 1		        	
		        },
		        {
		            dataIndex: 'fechaVisita',
		            text: HreRem.i18n('header.fecha.visita'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        }
		        
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'visitasComercialPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{visitasComercial}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});

