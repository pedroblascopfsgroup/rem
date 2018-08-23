Ext.define('HreRem.view.expedientes.SeguroRentasExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'segurorentasexpediente',
    cls: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'seguroRentasExpediente',
    scrollable: 'y',
    
	recordName: "segurorentasexpediente",
	
	recordClass: "HreRem.model.SeguroRentasExpediente",
    
    requires: ['HreRem.model.SeguroRentasExpediente'],
    
    listeners: {
		boxready:	'cargarTabData'
    },
    
    initComponent: function() {
        var me = this;
        me.setTitle(HreRem.i18n('title.seguro.rentas'));
        var items = [
        		{
                    xtype: 'fieldset',
                    title: HreRem.i18n('title.detalle'),
                    items: [
	        			{
	        				xtype: 'comboboxfieldbase',
	                        fieldLabel: HreRem.i18n('fieldlabel.estado.rentas'),
	                        reference: 'comboboxfieldEstado',
		                	bind: {
								store: '{comboEstadoSeguroRentas}',
								value: '{segurorentasexpediente.estado}'
		                	},
            				displayField: 'descripcion',
							valueField: 'codigo',
	        			 	listeners: {
	        			 			change:	'habilitarcheckrevisionOnChange'			
	        			 	}
	        			},
	        			{
	                        
	                    	xtype: 'textfieldbase',
	                        fieldLabel: HreRem.i18n('fieldlabel.motivo.rechazo'),
	                        reference: 'textfieldmotivo',
	                        bind: '{segurorentasexpediente.motivoRechazo}',
	                        readOnly: true

	                     },
	                     {
	                    	 xtype: 'textfieldbase',
	                         fieldLabel: HreRem.i18n('fieldlabel.aseguradoras'),
	                         reference: 'extfieldaseguradoras',
	                         bind: '{segurorentasexpediente.aseguradoras}',
	                         maxLength: 50

	                     },
	                     {
	                    	 xtype: 'textfieldbase',
	                         fieldLabel: HreRem.i18n('fieldlabel.emailPoliza'),
	                         bind: '{segurorentasexpediente.emailPoliza}',
	                         maxLength: 50

	                     },
	                     {
	                         xtype: 'checkboxfieldbase',
	                         fieldLabel: HreRem.i18n('fieldlabel.en.revision'),
	                         reference: 'chkboxEnRevision',
	 						 bind:{
	 							 value:'{segurorentasexpediente.revision}',
	 							 readOnly: '{!esExpedienteBloqueado}'
	 						 },
	                         listeners: {
	                             change: 'onchkbxEnRevisionChange'

	                         }
	                     	
	                     },
	                     {
                             xtype: 'textareafieldbase',
                             fieldLabel: HreRem.i18n('fieldlabel.comentarios'),
                             reference: 'textareafieldsegurocomentarios',
     						 bind:{
     							value:  '{segurorentasexpediente.comentarios}',
    							disabled: '{!enRevision}'
     						 },	
                             maxWidth: 500,
                             maxLength: 200
	                     }
                    ]
        		},
                {
                    xtype: 'fieldset',
                    title: HreRem.i18n('title.historico'),
                    items: [

                        {
                            xtype: 'gridBaseEditableRow',
                            idPrincipal: 'id',
                            cls: 'panel-base shadow-panel',

    						bind: {
    							store: '{storeHstcoSeguroRentas}'
    						},
                            columns: [
                                {
                                    text: HreRem.i18n('header.fecha.sancion.rentas'),
                                    dataIndex: 'fechaSancion',
                                    flex: 1,
                                    formatter: 'date("d/m/Y")'
                                },
                                {
                                    text: HreRem.i18n('fieldlabel.proveedor.resultado'),
                                    dataIndex: 'proveedor',
                                    flex: 1
                                },
                                {
                                    text: HreRem.i18n('fieldlabel.solicitud'),
                                    dataIndex: 'solicitud',
                                    flex: 1
                                },
                                {
                                    text: HreRem.i18n('header.documento'),
                                    dataIndex: 'docSco',
                                    flex: 1
                                },
                                {
                                    text: HreRem.i18n('fieldlabel.meses.fianza'),
                                    dataIndex: 'mesesFianza',
                                    flex: 1
                                },
                                {
                                    text: HreRem.i18n('fieldlabel.importe.fianza'),
                                    dataIndex: 'importeFianza',
                                    flex: 1

                                }
                            ]
                        }
                    ]
                }
            ];

        me.addPlugin({
            ptype: 'lazyitems',
            items: items
        });
        me.callParent();
    },
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);		
    }
});