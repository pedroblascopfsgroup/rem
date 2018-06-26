Ext.define('HreRem.view.agenda.AgendaListGestorSustituto', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'agendalistgestorsustituto',
	bind: {
		store: '{tareasGestorSustituto}'
	},
	
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle(HreRem.i18n('title.listado.tareas'));
	    me.listeners = {
			rowdblclick: 'onAgendaListDobleClick'
	     };
	     
	    me.columns = [
	               
	            /*{
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
	            },*/
			    {
			        xtype: 'actioncolumn',
			        width: 30,
			        hidden: true,
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
	                dataIndex: 'idTarea',
	                hideable: false
	            },
	            {
	                text     : HreRem.i18n('header.tarea'),
	                flex     : 5,
	                dataIndex: 'descripcionTarea'
	            }, 
	            {
	            	text	 : HreRem.i18n('header.tramite'),
	            	flex	 : 1,
	            	dataIndex: 'idTramite'
	            },
	            {
	                text     : HreRem.i18n('header.tipo.tramite'),
	                flex     : 2,
	                dataIndex: 'tipoTramite'
	            },
	            {
	            	text     : HreRem.i18n('header.responsable'),
	                flex     : 2,
	                dataIndex: 'usuarioResponsable'
	            },
	            {                
	                text	 : HreRem.i18n('header.fecha.inicio'),             
	                flex	 : 1,
	                dataIndex: 'fechaInicio',
	                align	 : 'center',
	                formatter: 'date("d/m/Y")'
	            },
	            {           
	                text	 : HreRem.i18n('header.fecha.vencimiento'),
	                flex	 : 1,
	                dataIndex: 'fechaFin',
	                align	 : 'center',
	                formatter: 'date("d/m/Y")'
	            },
	            {
	                text     : HreRem.i18n('header.plazo.vencer'),
	                flex     : 1,
	                dataIndex: 'plazoVencimiento',
	                align	 : 'center'     
	            },
	            {
	                text     : HreRem.i18n('header.prioridad'),
	                flex     : 0.5,
	                dataIndex: 'prioridad',
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
	                }
	            }/*, 
	            {               
	                text	 : HreRem.i18n('header.id.gestor'),
	                flex	 : 1,
	                dataIndex: 'idGestor',
	                hidden	 : true,
	                hideable : false
	            }  */   
	
	        ];
	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'agendaPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{tareasGestorSustituto}'
	            }
	        }
	    ];
	    
	    me.callParent();
	    
    }
    
});