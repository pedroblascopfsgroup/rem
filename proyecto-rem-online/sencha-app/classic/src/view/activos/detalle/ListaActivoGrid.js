Ext.define('HreRem.view.activos.detalle.ListaActivoGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'listaActivoGrid',
	topBar		: false,
	propagationButton: false,
	targetGrid	: 'listaActivoGrid',
	idPrincipal : 'id',
	editable: false,
	editOnSelect: false,
	requires : ['HreRem.model.ListaActivoGrid'],
	
	 
    bind: {
       store: '{storeDatosActivo}'
    },
    

    initComponent: function () {

     	var me = this;
     	
     	 me.selModel = {
          selType: 'checkboxmodel',
          mode: 'SINGLE'
      	}; 
		 
		me.columns = [
				{
					text: 'Id Activo',
					dataIndex: 'activoId',
					hidden: true,
					hideable: false
				},
				{	  
		            text: HreRem.i18n('fieldlabel.numero.activo'),				            
		            dataIndex: 'numActivo',
		            flex: 1
				},
				{   text: HreRem.i18n('header.finca.registral'),
					dataIndex: 'fincaRegistral',
		        	flex: 1
				},
				{   text: HreRem.i18n('header.tipo.activo'),
		        	dataIndex: 'tipoActivo',
		        	flex: 1
				},
				{   text: HreRem.i18n('header.subtipo.activo'),
		        	dataIndex: 'subtipoActivo',
		        	flex: 1
				},
				{
					text: HreRem.i18n('fieldlabel.cliente.ursus.municipio'),
					dataIndex: 'municipio',
					flex: 1
				},
				{
					text: HreRem.i18n('fieldlabel.cliente.ursus.provincia'),
					dataIndex: 'provincia',
					flex: 1
				}
		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		               store: '{storeDatosActivo}'
		            }
		        }
		    ];
		    

		    me.callParent();
   }

});
