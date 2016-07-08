Ext.define('HreRem.view.trabajos.detalle.SeleccionTarifasTrabajo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'selecciontarifastrabajo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.5,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    closable: true,		
    closeAction: 'hide',
    		
    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    
	initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n('title.seleccion.tarifa'));
    	
    	
    	me.items = [
    		   {
	            	xtype: 'fieldsettable',
	            	defaultType: 'textfieldbase',
	            	items: [
						{
							fieldLabel:  HreRem.i18n('fieldlabel.propietario'),
							//width: 		260,
							bind: ''
						},
						{
							xtype: 'currencyfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.saldo.disponible.activo'),
							//width: 		260,
							bind: ''
						},
						{
							fieldLabel:  HreRem.i18n('fieldlabel.entidad.propietaria'),
							//width: 		260,
							bind: ''
						}      
	            	]
	            },
	            {
	            	xtype		: 'gridBase',
					layout:'fit',
					minHeight: 150,
					colspan:	3,
					topBar: true,
					cls	: 'panel-base shadow-panel',
					height: '100%',
					bind: {
						store: ''
					},
					columns: [
					    {   text: HreRem.i18n('header.codigo.tarifa'),
				        	dataIndex: '',
				        	editable: false,
				        	flex: 1
				        },
				        {   text: HreRem.i18n('header.descripcion'),
				        	dataIndex: '',
				        	editable: false,
				        	flex: 1
				        },	
				        {   text: HreRem.i18n('header.precio.unitario'),
				        	dataIndex: '',
				        	editable: false,
				        	flex: 1 
				        }
				    ]
	            }
    	];
    	
    	me.callParent();
    }
});