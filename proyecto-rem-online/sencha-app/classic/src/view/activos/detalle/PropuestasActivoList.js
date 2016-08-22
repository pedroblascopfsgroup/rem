Ext.define('HreRem.view.activos.detalle.PropuestasActivoList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'propuestasactivolist',

    bind: {
        store: '{storePropuestasActivo}'
    },
        
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
		        	xtype: 'actioncolumn',
		            dataIndex: 'numTrabajo',
		            text: HreRem.i18n('header.num.trabajo'),
		            items: [{
			            tooltip: HreRem.i18n('tooltip.ver.trabajo'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("numTrabajo"))) {
			            		return 'app-list-ico ico-pestana-trabajos';
			            	}			            	
			            },
			            handler: 'onEnlaceTrabajoClick'
			        }],
			        renderer: function(value, metadata, record) {
			        	if(Ext.isEmpty(record.get("numTrabajo"))) {
			        		return "";
			        	} else {
			        		return '<div style="display:inline; margin-right: 15px; font-size: 11px;">'+ value+'</div>'
			        	}
			        },
		            flex: 1,
		            align: 'center'
		            //hidden: true		        	
		        },
		        {	        	
		           /* dataIndex: 'idTramite',
		            text: HreRem.i18n('header.tramite'),
		            flex: 1,
		            hidden: true
		            */
		            
		            xtype: 'actioncolumn',
	    			text: HreRem.i18n('header.tramite'),
		        	dataIndex: 'idTramite',
			        items: [{
			            tooltip: HreRem.i18n('tooltip.ver.tramite'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("idTramite"))) {
			            		return 'app-list-ico ico-ver-tarea';
			            	}			            	
			            },
			            handler: 'onEnlaceTramiteClick'
			        }],
			        renderer: function(value, metadata, record) {
			        	if(Ext.isEmpty(record.get("idTramite"))) {
			        		return "";
			        	} else {
			        		return '<div style="display:inline; margin-right: 15px; font-size: 11px;">'+ value+'</div>'
			        	}
			        },
		            flex     : 1,            
		            align: 'center'
		        },
		        {	        	
		            dataIndex: 'entidadPropietariaDescripcion',
		            text: HreRem.i18n('header.cartera'),
		            flex: 1,
		            hidden: true        	
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
		            dataIndex: 'estadoActivoCodigo',
		            text: HreRem.i18n('fieldlabel.estado.activo.propuesta'),
		            flex: 1,
		            renderer: function(value) {
		            	var record = me.lookupController().getViewModel().get("comboEstadosPropuestaActivo").findRecord("codigo", value);
		            	if(Ext.isEmpty(record)) {
		            		return "-";
		            	} else {
		            		return record.get("descripcion");
		            	}
		            	
		            }
		            
		        },
		        {	        	
		            dataIndex: 'motivoDescarte',
		            text: HreRem.i18n('header.motivo.descarte'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'observaciones',
		            text: HreRem.i18n('header.observaciones'),
		            flex: 1,
		            hidden: true
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
		                store: '{storePropuestasActivo}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});

