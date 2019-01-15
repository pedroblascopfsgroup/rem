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
                    xtype: 'fieldsettable',
                    title: HreRem.i18n('title.detalle'),
                    items: [
	        			{
	        				xtype: 'textfieldbase',
	                        fieldLabel: HreRem.i18n('fieldlabel.estado.rentas'),
		                	bind: {
								value: '{segurorentasexpediente.estado}'
		                	},
		                	readOnly: true
	        			},
	                    {
	                    	 xtype: 'textfieldbase',
	                         fieldLabel: HreRem.i18n('fieldlabel.aseguradoras'),
	                         reference: 'extfieldaseguradoras',
	                         bind: '{segurorentasexpediente.aseguradoras}',
	                         maxLength: 50,
	                         readOnly: true

	                     },
	                     {
	                    	 xtype: 'textfieldbase',
	                         fieldLabel: HreRem.i18n('fieldlabel.emailPoliza'),
	                         bind: '{segurorentasexpediente.emailPoliza}',
	                         maxLength: 50,
	                         readOnly: true

	                     },
	                     {
	                         xtype: 'checkboxfieldbase',
	                         fieldLabel: HreRem.i18n('fieldlabel.en.revision'),
	                         reference: 'chkboxEnRevision',
	 						 bind:{
	 							 value:'{segurorentasexpediente.revision}',
	 							 readOnly: '{!estaEnTramite}'
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
	                     },
        				{
		                	xtype: 'button',
		                	margin:'10 0 10 0',
		                	reference: 'btnReenviarMailAsegurador',      		                	
		        		    bind:{
		        		    	hidden: '{!expediente.estaFirmado}',
		        		    	disabled: '{!expediente.estaFirmado}'
		        		    },
		                	text: HreRem.i18n('btn.reenviar.mail.asegurador'),
		                	handler: 'onClickEnviarEmailAsegurador'
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
        					        xtype: 'actioncolumn',
        					        width: 30,
	        					    hideable: false,
        					        items: [{
        					           	iconCls: 'ico-download',
        					           	tooltip: HreRem.i18n("tooltip.download"),
        					            handler: function(grid, rowIndex, colIndex) {
        					                var record = grid.getRecord(rowIndex);
        					                var idActivo=record.get("idActivo");
        					                if(!Ext.isEmpty(idActivo)){
	        					               //Todo lo que viene a continuación, es para descargar el fichero
	        					                config = {};
												config.url=$AC.getWebPath()+"activo/bajarAdjuntoActivo."+$AC.getUrlPattern();
												config.params = {};
												config.params.id=record.get('identificador');
												config.params.idActivo=record.get("idActivo"); 
												
												config = config || {};
		    
											    var url = config.url,
											        method = config.method || 'GET',// Either GET or POST. Default is POST.
											        params = config.params || {};
											    var form = Ext.create('Ext.form.Panel', {
											        standardSubmit: true,
											        url: url,
											        method: method
											    });
											    form.submit({
											        target: '_blank', 
											        params: params
											    });
											    Ext.defer(function(){
											        form.destroy();
											    }, 1000);
        					                 				                
        					                }else {
        					                	me.fireEvent("errorToast", "No hay adjunto ningun documento de tipo Seguro rentas");
        					                }
        					            }
        					        }]
        			    		},
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