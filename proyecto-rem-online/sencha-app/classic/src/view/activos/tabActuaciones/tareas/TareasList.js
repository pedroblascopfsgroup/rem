//Ext.define('HreRem.view.activos.actuaciones.tareas.TareasList', {
//	extend		: 'HreRem.view.common.GridBase',
//    xtype		: 'tareaslist',
//    minHeight 	: 200,   
//	cls	: 'panel-base shadow-panel',	 
//    
//    bind: {
//        store: '{tareas}'
//    },
//    
//    listeners: {
//    	itemdblclick: 'onEditDblClick'
//    },
//
//    columns: [
//        {
//            dataIndex: 'idTarea',
//            text: 'Id Tarea',
//            hidden: true,
//            flex: 1
//        },
//        {
//            dataIndex: 'idActuacion',
//            text: 'Id Actuacion',
//            hidden: true,
//            flex: 1
//        },
//        {
//            dataIndex: 'nombreTarea',
//            text: 'Tarea',
//            flex: 3
//        },
//        {
//            dataIndex: 'idTipoActuacion',
//            text: 'Id Tipo Actuación',
//            hidden: true,
//            flex: 1
//        },
//        {
//            dataIndex: 'idTipoActuacionPadre',
//            text: 'Id Actuación Origen',
//            hidden: true,
//            align: 'center',
//            flex: 1
//        },
//        {
//            dataIndex: 'tipoActuacion',
//            text: 'Tipo Actuación',
//            flex: 3
//        },
//        {
//            dataIndex: 'idActivo',
//            hidden: true,
//            text: 'Id Activo',
//            flex: 1
//        },       
//        {
//            dataIndex: 'fechaInicio',
//            text: 'F. Inicio',
//            align: 'center',
//            flex: 1
//        },
//        {
//            dataIndex: 'fechaFin',
//            text: 'F. Fin',
//            align: 'center',
//            flex: 1
//        },
//        {
//            dataIndex: 'idGestor',
//            text: 'Id Gestor',
//            hidden: true,
//            flex: 1
//        },
//        {
//            dataIndex: 'gestor',
//            text: 'Gestor',
//            flex: 2
//        }
//    ]/*,
//    dockedItems: [
//        {
//            xtype: 'pagingtoolbar',
//            dock: 'bottom',
//            itemId: 'tareasActivasPaginationToolbar',
//            displayInfo: true,
//            bind: {
//                store: '{tareas}'
//            }
//        }
//    ]*/
//});