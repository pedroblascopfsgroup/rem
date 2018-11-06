Ext.define('HreRem.view.activos.detalle.VisitasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'visitascomercialactivolist',
    bind: {
        store: '{storeVisitasActivo}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.listeners = {	    	
			rowdblclick: 'onVisitasListDobleClick'
	     }
        
        me.columns= [
        
		         {
		        	
		            dataIndex: 'numVisita',
		            text: HreRem.i18n('header.numero.visita'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaSolicitud',
		            text: HreRem.i18n('header.fecha.solicitud'),
		            formatter: 'date("d/m/Y")',
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
		        {
		            dataIndex: 'estadoVisitaDescripcion',
		            text: HreRem.i18n('header.estado.visita'),
		            flex: 1
		        },
		        {
		            dataIndex: 'subEstadoVisitaDescripcion',
		            text: HreRem.i18n('header.subestado.visita'),
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
		            itemId: 'visitasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeVisitasActivo}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});

