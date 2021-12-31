Ext.define('HreRem.view.comercial.pbc.InvervinientesGrid', {
    extend		: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype		: 'intervinientesGrid',
	topBar		: false,
	editOnSelect: false,
	disabledDeleteBtn: true,
	
    initComponent: function () {

     	var me = this;
     	
     	me.title= HreRem.i18n('Intervinientes');
     	me.columns= [

		   {    text: HreRem.i18n('header.id.cliente'),
	        	//dataIndex: '',
	        	flex: 1,
	        	hidden: true, 
	        	hideable: false
	       },
		   {
				text: HreRem.i18n('header.nombre.razon.social'),
				//dataIndex: '',
				flex: 1
		   },
		   {
				text: HreRem.i18n('fieldlabel.apellidos.cliente'),
				//dataIndex: '',
				flex: 1
		   },
		   {
		   		text: HreRem.i18n('header.tipo.documento'),
	            //dataIndex: '',
	            flex: 1
		   },
		   {
		   		text: HreRem.i18n('header.numero.documento'),
	            //dataIndex: '',
	            flex: 1
		   },						   
		   {
		   		text: HreRem.i18n('header.rol.oferta'),
	            //dataIndex: '',
	            flex: 1
		   }
		   
		];
//     	 me.dockedItems : [
//	        {
//	            xtype: 'pagingtoolbar',
//	            dock: 'bottom',
//	            displayInfo: true,
//	            bind: {
//	                //store: '{}'
//	            }
//	        }
//		]

		    me.callParent();
    }
});
