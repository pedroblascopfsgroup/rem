Ext.define('HreRem.view.agenda.AgendaListDash', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'agendalistdash',
    //reference: 'agendalist',
	title: 'Listado de Tareas',
	bind: {
		store: '{agendaItems}'
	},
    viewModel: {
        type: 'agenda'
    },   
    listeners        : {
		rowdblclick: 'onEnlaceTareasClick'
     },
    columns : [
               
		    {               
                text	 : 'Id Actuacion',
                flex	 : 1,
                dataIndex: 'idActuacion',
                hidden	 : true
            },
            {
                text	 : 'Id Tipo Actuación',               
                flex	 : 1,
                dataIndex: 'idTipoActuacion',
                hidden	 : true                
            },
            {
            	text	 : 'Id Actuación Origen',
            	flex	 : 1,
                dataIndex: 'idTipoActuacionPadre',
                align	 : 'center',
                hidden	 : true  
            },
            {
                text     : 'Id Tarea',
                flex     : 1,
                dataIndex: 'idTarea',
                hidden	 : true
            },
            {
                text     : 'Tarea',
                flex     : 2,
                dataIndex: 'nombreTarea'
            },          
            {
            	text	 : 'Id Activo',
                flex	 : 1,
                dataIndex: 'idEntidad',
                hidden	 : true            
            },         
            {                
                text	 : 'F. Inicio',              
                flex	 : 1,
                dataIndex: 'fechaInicioCalc',
                align	 : 'center'
            },
            {              
                text	 : 'F. Fin',
                flex	 : 1,
                dataIndex: 'fechaFin',
                align	 : 'center',
                hidden	 : true  
            },
            {           
                text	 : 'F. Vencimiento',
                flex	 : 1,
                dataIndex: 'fechaVencReal',
                align	 : 'center'              
            },
            {
                text     : 'Plazo',
                flex     : 1,
                dataIndex: 'diasVencidaNumber',
                align	 : 'center'     
            },
            {
                text     : 'Prioridad',
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
                }
            }     

        ]
    
});