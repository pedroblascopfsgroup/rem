Ext.define('HreRem.view.comercial.ofertas.OfertasComercialList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'ofertascomerciallist',
    bind: {
        store: '{ofertasComercial}'
    },
	loadAfterBind: false,
    initComponent: function () {
        
        var me = this;
        me.setTitle(HreRem.i18n('title.lista.ofertas'));
       	me.listeners = {	    	
			rowdblclick: 'onOfertasListDobleClick'
	     };

        var userPefSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
	    
        me.columns= [
        
		        {
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
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
		            dataIndex: 'numActivoAgrupacion',
		            text: HreRem.i18n('header.numero.activo.agrupacion'),
		            flex: 1,
		            items: [{
			            tooltip: HreRem.i18n('tooltip.ver.activo.agrupacion'),
			            getClass: function(v, metadata, record ) {
			            	if (Ext.isEmpty(record.get("numAgrupacion"))) {
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
		            align: 'center',
		            hideable: false,
		            sortable: true
		        },
		        {	        	
		        	dataIndex: 'descripcionEstadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
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
		            hideable: false,
		            sortable: true
		        },
		        {
		            dataIndex: 'descripcionEstadoExpediente',
		            text: HreRem.i18n('header.oferta.estadoExpediente'),
		            flex: 1
		        },
		        {
		        	xtype: 'actioncolumn',
	    			text: HreRem.i18n('header.oferta.visita'),
		        	dataIndex: 'numVisita',
			        items: [{
			            tooltip: HreRem.i18n('tooltip.ver.visita'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("numVisita"))) {
			            		return 'ico-ver-visita';
			            	}			            	
			            },
			            handler: 'onClickAbrirVisita'
			        }],
			        renderer: function(value, metadata, record) {
			        	if(Ext.isEmpty(record.get("numVisita"))) {
			        		return "";
			        	} else {
			        		return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        	}
			        },
		            flex     : 1,            
		            align: 'center',
		            hideable: false,
		            sortable: true		        	
		        }, 
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.ofertante'),
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            flex: 1,
		            align: 'right',
			        renderer: function(value, metadata, record) {
			        	if (!userPefSuper && record.get("concurrenciaActiva") == 1) {
			        		return "*****";
			        	} else {
			        		return  Ext.util.Format.number(value, '0.00');
			        	}
			        }
		        },
		        /*{
		            dataIndex: 'gestorFormalizacion',
		            text: HreRem.i18n('header.gestor.formalizacion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'gestoria',
		            text: HreRem.i18n('header.gestoria'),
		            flex: 1
		        },*/
		        {
		            dataIndex: 'canalDescripcion',
		            text: HreRem.i18n('header.canal.prescripcion'),
		            flex: 1
		        },
		        {
		        	text: HreRem.i18n('header.oferta.express'),
					dataIndex: 'ofertaExpress',
					align	 : 'center',
					hideable: false,
					renderer: function(data) {
						if(data == 1){
							var png = 'resources/images/green_16x16.png';
							return '<div> <img src="'+ png +'"></div>';
							 		 }
	                }
						
				}
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

