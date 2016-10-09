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
        
        me.listeners = {	    	
			rowdblclick: 'onVisitasListDobleClick'
	     }
        
        me.columns= [
        		{	        	
		            dataIndex: 'id',
		            text: HreRem.i18n('header.numero.visita'),
		            flex: 1,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'numVisita',
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
		            hideable: false,
		            sortable: true
		        },
		        {
		            dataIndex: 'fechaSolicitud',
		            text: HreRem.i18n('header.fecha.solicitud'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'estadoVisitaDescripcion',
		            text: HreRem.i18n('header.estado.visita'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'nombreCompleroCliente',
		            text: HreRem.i18n('header.nombre'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'documentoCliente',
		            text: HreRem.i18n('header.numero.documeto'),
		            flex: 1		        	
		        },
		        {
		            dataIndex: 'fechaVisita',
		            text: HreRem.i18n('header.fecha.visita'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        //campos ocultos para el detalle
		        {	        	
		            dataIndex: 'numVisita',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'idActivo',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'idActivo',
		            hidden: true
		        },
		        {
		            dataIndex: 'fechaConcertacion',
		            formatter: 'date("d/m/Y")',
		            hidden: true
		        },
		        {
		            dataIndex: 'fechaContacto',
		            formatter: 'date("d/m/Y")',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'observacionesVisita',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'subEstadoVisitaCodigo',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'subEstadoVisitaDescripcion',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'estadoVisitaCodigo',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'estadoVisitaDescripcion',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'idCliente',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'nombreCompleroCliente',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'documentoCliente',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'documentoRepresentanteCliente',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'telefono1Cliente',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'telefono2Cliente',
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'emailCliente',
		            hidden: true
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

