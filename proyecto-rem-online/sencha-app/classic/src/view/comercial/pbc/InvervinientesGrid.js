Ext.define('HreRem.view.comercial.pbc.InvervinientesGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'intervinientesGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
    bind		: {
        store: '{storeGridIntervinientes}'
    },
	
    initComponent: function () {

     	var me = this;
     	
     	me.title= HreRem.i18n('header.intervinientes');
     	me.columns= [

		   {    text: HreRem.i18n('header.id.cliente'),
	        	//dataIndex: '',
	        	flex: 1,
	        	hidden: true, 
	        	hideable: false
	       },
		   {
				text: HreRem.i18n('header.nombre.razon.social'),
				dataIndex: 'nombre',
				flex: 1
		   },
		   {
				text: HreRem.i18n('fieldlabel.apellidos.cliente'),
				dataIndex: 'apellidos',
				flex: 1
		   },
		   {
		   		text: HreRem.i18n('header.tipo.documento'),
	            dataIndex: 'tipoDocumento',
	            flex: 1
		   },
		   {
		   		text: HreRem.i18n('header.numero.documento'),
	            dataIndex: 'numDocumento',
	            flex: 1
		   },						   
		   {
		   		text: HreRem.i18n('header.rol.oferta'),
	            dataIndex: 'rol',
	            flex: 1
		   }
		   
		];

		me.callParent();
    }
});
