Ext.define('HreRem.view.agenda.AgendaAvisosList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'agendaavisoslist',
	bind: {
		store: '{tareasavisos}'
	},
	
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle("Avisos");
     	
	    me.listeners = {
			rowdblclick: 'onAgendaListDobleClick'
	     };
	     
	    me.columns = [
	               
	  	        {
				     xtype: 'actioncolumn',
				     width: 30,
				     handler: 'onEnlaceActivosClick',
				     items: [{
				         tooltip: 'Ver Activo',
				         iconCls: 'app-list-ico ico-ver-activov2',
				         isDisabled: function(view, rowIndex, colIndex, item, record) {
				             return Ext.isEmpty(record.get("idEntidad"));
				         }
				     }],
				     hideable: false
		        },
			    {
			        xtype: 'actioncolumn',
			        width: 30,
			        handler: 'onEnlaceTareasClick',
			        items: [{
			            tooltip: 'Ver Tarea',
			            iconCls: 'app-list-ico ico-ver-tarea'
			        }],
			        hideable: false
			    } ,  
	            {
	            	text	 : HreRem.i18n('header.numero.tarea'),
	                flex	 : 1,
	                dataIndex: 'id',
	                hidden: true,
	                hideable: false
	            }, 
			    {               
	                text	 : HreRem.i18n('header.id.actuacion'),
	                flex	 : 1,
	                dataIndex: 'idActuacion',
	                hidden	 : true,
	                hideable : false
	            },
	            {
	                text	 : HreRem.i18n('header.id.tipo.actuacion'),               
	                flex	 : 1,
	                dataIndex: 'idTipoActuacion',
	                hidden	 : true,
	                hideable : false
	            },
	            {
	            	text	 : HreRem.i18n('header.id.actuacion.origen'), 
	            	flex	 : 1,
	                dataIndex: 'idTipoActuacionPadre',
	                align	 : 'center',
	                hidden	 : true,
	                hideable : false
	            },
	            {               
	                text	 : HreRem.i18n('header.tipo.actuacion'),
	                flex	 : 2,
	                dataIndex: 'tipoActuacion',
	                hidden	 : true,
	                hideable : false
	            },
	            {
	                text     : HreRem.i18n('header.id.tarea'),
	                flex     : 1,
	                dataIndex: 'idTarea',
	                hidden	 : true,
	                hideable : false
	            },
	            {
	            	text	 : HreRem.i18n('header.id.activo'),
	                flex	 : 1,
	                dataIndex: 'codEntidad'
	            }, 
	            {
	                text     : HreRem.i18n('header.tarea'),
	                flex     : 5,
	                dataIndex: 'nombreTarea',
	                renderer: function(value,p,r){
	                	return r.data['nombreTarea'] + '   ( ' + r.data['descripcionTarea'] + ' )';
	                }
	            },          
	            {
	                text     : HreRem.i18n('header.titulo'),
	                flex     : 5,
	                hidden	 : true,
	                dataIndex: 'descripcionTarea'
	            }, 
	            {
	            	text	 : HreRem.i18n('header.id.activo'),
	                flex	 : 1,
	                dataIndex: 'idActivo',
	                hidden	 : true,
	                hideable : false
	            },     
	            {
	                text     : HreRem.i18n('header.tipo.tramite'),
	                flex     : 2,
	                dataIndex: 'descripcionEntidad',
	                hidden: true
	            },
	            {
	            	text     : HreRem.i18n('header.responsable'),
	                flex     : 2,
	                dataIndex: 'gestor'
	            },
	            {                
	                text	 : HreRem.i18n('header.fecha.inicio'),             
	                flex	 : 1,
	                dataIndex: 'fechaInicio',
	                align	 : 'center',
		            formatter: 'date("d/m/Y")'
	            },
	            {              
	                text	 : HreRem.i18n('header.fecha.fin'), 
	                flex	 : 1,
	                dataIndex: 'fechaFin',
	                align	 : 'center',
	                hidden	 : true,
	                hideable : false,
	                formatter: 'date("d/m/Y")'
	            },
	            {           
	                text	 : HreRem.i18n('header.fecha.vencimiento'),
	                flex	 : 1,
	                dataIndex: 'fechaVenc',
	                align	 : 'center',
	                hidden	 : true,
	                formatter: 'date("d/m/Y")'
	            },
	            {
	                text     : HreRem.i18n('header.plazo.vencer'),
	                flex     : 1,
	                dataIndex: 'diasVencidaNumber',
	                align	 : 'center',
	                hidden	 : true
	            },
	            {
	                text     : HreRem.i18n('header.prioridad'),
	                flex     : 0.5,
	                dataIndex: 'semaforo',
	                align	 : 'center',
	                renderer: function(data) {
	                	if(data == '2'){
	                		var data = 'resources/images/red_16x16.png';
	                		return '<div> <img src="'+ data +'"></div>';
					    }else if(data == '1'){
					    	var data = 'resources/images/yellow_16x16.png'
					    	return '<div> <img src="'+ data +'"></div>';
					    }else{
					    	var data = 'resources/images/green_16x16.png'
					    	return '<div> <img src="'+ data +'"></div>';
					    }
	                },
	                hidden: true
	            }, 
	            {               
	                text	 : HreRem.i18n('header.id.gestor'),
	                flex	 : 1,
	                dataIndex: 'idGestor',
	                hidden	 : true,
	                hideable : false
	            }     
	
	        ];
	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'agendaAvisosPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{tareasavisos}'
	            }
	        }
	    ];
	    
	    me.callParent();
	    
    }
    
});