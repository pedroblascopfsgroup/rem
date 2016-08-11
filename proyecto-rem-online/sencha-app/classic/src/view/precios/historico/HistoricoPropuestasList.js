Ext.define('HreRem.view.precios.historico.HistoricoPropuestasList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicopropuestaslist',

    bind: {
        store: '{propuestas}'
    },
    listeners : [
    	{rowclick: 'onPropuestaPrecioListClick'}
    ],
    
    loadAfterBind: false,
    initComponent: function () {
        
        var me = this;        
        
        me.columns= [
        
		        {	        	
		            dataIndex: 'numPropuesta',
		            text: HreRem.i18n('header.numero.propuesta'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'nombrePropuesta',
		            text: HreRem.i18n('header.nombre.propuesta'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'numTramite',
		            text: HreRem.i18n('header.tramite'),
		            flex: 1,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'numTrabajo',
		            text: HreRem.i18n('header.num.trabajo'),
		            flex: 1,
		            hidden: true		        	
		        },
		        {	        	
		            dataIndex: 'entidadPropietariaDescripcion',
		            text: HreRem.i18n('header.cartera'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'tipoPropuesta',
		            text: HreRem.i18n('header.tipo.propuesta'),
		            flex: 1,
		            renderer: function(value) {
		            	var record = me.lookupController().getViewModel().get("comboTiposPropuesta").findRecord("codigo", value);
		            	if(Ext.isEmpty(record)) {
		            		return "-";
		            	} else {
		            		return record.get("descripcion");
		            	}
		            	
		            }
		            
		        },
		        {	        	
		            dataIndex: 'estadoDescripcion',
		            text: HreRem.i18n('header.estado'),
		            flex: 1
		        },
		        {	        	
		        	dataIndex: 'fechaEmision',
		            text: HreRem.i18n('header.fecha.emision'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaEnvio',
		            text: HreRem.i18n('header.fecha.envio'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaSancion',
		            text: HreRem.i18n('header.fecha.sancion'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'fechaCarga',
		            text: HreRem.i18n('header.fecha.carga'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {	        	
		            dataIndex: 'gestor',
		            text: HreRem.i18n('header.gestor'),
		            flex: 1		
		        },
		        {	        	
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('header.observaciones'),
		            flex: 1		        	
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'propuestasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{propuestas}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});

