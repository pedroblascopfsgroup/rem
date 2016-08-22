Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.juridicas.SaneamientosList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'saneamientoslist',
    //minHeight 	: 250,   
	cls	: 'panel-base shadow-panel',
	title: 'Saneamiento',
	padding: '0 0 150 0',
    
    bind: {
        store: '{saneamientos}'
    },
    


    columns: [

        {
            dataIndex: 'idActivo',
            text: 'Id Activo',
            hidden: true,
            flex: 1
        },
        {
            dataIndex: 'idOferta',
            text: 'Id Oferta',
            hidden: true,
            flex: 1
        },
        {
        	 dataIndex: 'cargaPendiente',
             text: 'Carga pendiente cancelar',
             flex: 1
        },        
        {
            dataIndex: 'importeCargaPendiente',
            text: 'Importe (€)',
            flex: 2
        },        
        {
            dataIndex: 'cuentaPendiente',
            text: 'Por cuenta de',
            flex: 2
        }
    ]/*,
    dockedItems: [
        {
            xtype: 'pagingtoolbar',
            dock: 'bottom',
            itemId: 'comisionesPaginationToolbar',
            displayInfo: true,
            bind: {
                store: '{saneamientos}'
            }
        }
    ]*/

});