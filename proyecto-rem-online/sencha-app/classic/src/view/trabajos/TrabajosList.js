Ext.define('HreRem.view.trabajos.TrabajosList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'trabajoslist',
	bind: {
		store: '{trabajos}'
	},
	
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle(HreRem.i18n('title.listado.trabajos'));
	    me.listeners = {	    	
			rowdblclick: 'onTrabajosListDobleClick'
	     };
	     
	    me.columns = [
	    
	    		{
	    			xtype: 'actioncolumn',
		        	dataIndex: 'tipoEntidad',
			        handler: 'onEnlaceActivosClick',
			        items: [{
			            tooltip: 'Ver Activo',
			            //iconCls: 'app-list-ico ico-ver-activov2',
			            isDisabled: function(view, rowIndex, colIndex, item, record) {
			            	if (record.get("tipoEntidad")!='activo')
			            		return true;
			            	else
			            		return false;
			            },
			            getClass: function(v, metadata, record ) {
			            	if (record.get("tipoEntidad")!='activo')
			            		return "app-list-ico ico-ver-agrupacion";
			            	else
			            		return "app-list-ico ico-ver-activov2";
			            	
			            }
			        }],
		            flex     : 0.5,            
		            align: 'center',
		            /*renderer: function(value) {
		            	return '<div> <img src="resources/images/ico_'+value+'_column.svg" alt="Rating" width="20px" height="20px" align="middle" vertical-align="middle"></div>';			
		            },*/
		            menuDisabled: true,
		            hideable: false
		        },	
		        {
	            	text	 : HreRem.i18n('header.numero.activo.agrupacion'),
	                flex	 : 1,
	                dataIndex: 'numActivoAgrupacion'
	            },  
	        
  				{
	            	text	 : HreRem.i18n('header.numero.trabajo'),
	                flex	 : 1,
	                dataIndex: 'numTrabajo'
	            },     
	            
	            {
		            text: HreRem.i18n('header.tipo'),
		           	flex	 : 1,
		           	dataIndex: 'descripcionTipo'
	            },		            
		        {
		           	text: HreRem.i18n('header.subtipo'),
		            flex	 : 1,
		            dataIndex: 'descripcionSubtipo'
		        },
	            {
	            	text	 : HreRem.i18n('header.estado'),
	                flex	 : 1,
	                dataIndex: 'descripcionEstado'
	            },
	            {
	            	text	 : HreRem.i18n('header.solicitante'),
	                flex	 : 1,
	                dataIndex: 'solicitante'
	            },
	            {
		            text: HreRem.i18n('header.proveedor'),
		            flex	 : 1,
		            dataIndex: 'proveedor'
	            
		        },
	            {   
	            	text	 : HreRem.i18n('header.fecha.peticion'),
	            	flex: 1,
	                dataIndex: 'fechaSolicitud',
			        formatter: 'date("d/m/Y")'					
			    },
			    {
			    	text: HreRem.i18n('header.poblacion'),
		            flex	 : 1,
		            dataIndex: 'descripcionPoblacion',
		            hidden: true
			    },
			    {
			    	text: HreRem.i18n('header.codigo.postal'),
		            flex	 : 1,
		            dataIndex: 'codPostal',
		            hidden: true
			    },
			    {
			    	text: HreRem.i18n('header.provincia'),
		            flex	 : 1,
		            dataIndex: 'descripcionProvincia',
		            hidden: true
			    }

	        ];
	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'trabajosPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{trabajos}'
	            }
	        }
	    ];
	    
	    me.callParent();
	    
    }
    
});