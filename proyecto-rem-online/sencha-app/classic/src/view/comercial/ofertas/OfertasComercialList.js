Ext.define('HreRem.view.comercial.ofertas.OfertasComercialList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertascomerciallist',
    bind: {
        store: '{ofertasComercial}'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.lista.ofertas'));
       	me.listeners = {	    	
			rowdblclick: 'onOfertasListDobleClick'
	     };
	    
        me.columns= [
        
		        {
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 1
		        },
		        {	  
		        	xtype: 'actioncolumn',
		            dataIndex: 'numActivoAgrupacion',
		            text: HreRem.i18n('header.numero.activo.agrupacion'),
		            flex: 1,
		            items: [{
			            tooltip: HreRem.i18n('tooltip.ver.expediente'),
			            getClass: function(v, metadata, record ) {
			            	if (Ext.isEmpty(record.get("idAgrupacion"))) {
			            		return 'app-list-ico ico-ver-activov2';
			            	}
			            	else{
			            		return 'app-list-ico ico-ver-agrupacion'
			            	}
			            },
			            handler: 'onClickAbrirActivoAgrupacion'
			        }],
			        renderer: function(value, metadata, record) {
			        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
			        },
		            flex     : 1,            
		            align: 'right',
//		            menuDisabled: true,
		            hideable: false,
		            sortable: true
		        },
		        {	        	
		            dataIndex: 'estadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
		            flex: 1		        	
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
	    			xtype: 'actioncolumn',
	    			text: HreRem.i18n('header.oferta.expediente'),
		        	dataIndex: 'numExpediente',
			        items: [{
			            tooltip: HreRem.i18n('tooltip.ver.expediente'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("numExpediente"))) {
			            		return 'fa fa-folder-open blue-medium-color';
			            	}			            	
			            },
			            handler: 'onClickAbrirExpedienteComercial'
			        }],
			        renderer: function(value, metadata, record) {
			        	if(Ext.isEmpty(record.get("numExpediente"))) {
			        		return "";
			        	} else {
			        		return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        	}
			        },
		            flex     : 1,            
		            align: 'center',
//		            menuDisabled: true,
		            hideable: false,
		            sortable: true
		        },
		        {
		            dataIndex: 'descripcionEstadoExpediente',
		            text: HreRem.i18n('header.oferta.estadoExpediente'),
		            flex: 1
		        },
		        /*{	        	
		            dataIndex: 'subtipoActivo',
		            text: HreRem.i18n('header.oferta.subtipoActivo'),
		            flex: 1		        	
		        },*/
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.ofertante'),
		            flex: 1
		        }
//NO ESTA DEFINIDO		        
//		        {
//		            dataIndex: 'comite',
//		            text: HreRem.i18n('header.oferta.comite'),
//		            flex: 1
//		        }
//NO ESTA DEFINIDO		        
//		        {
//		            dataIndex: 'derechoTanteo',
//		            text: HreRem.i18n('header.oferta.derechoTanteo'),
//		            flex: 1
//		        }
		        
		        
		        
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasComercialPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{ofertasComercial}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});

