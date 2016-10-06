Ext.define('HreRem.view.expedientes.ReservaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'reservaexpediente',    
    disableValidation: true,
    reference: 'reservaExpediente',
    scrollable	: 'y',

	recordName: "reserva",
	
	recordClass: "HreRem.model.Reserva",
    
    requires: ['HreRem.model.Reserva'],
    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.reserva'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.reserva'),
				items :
					[
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.reserva'),
		                	bind:		'{reserva.numReserva}'
		                },
		                { 
							xtype: 'comboboxfieldbase',
							reference: 'comboTiposArras',
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo.arras'),
				        	bind: {
			            		store: '{storeTiposArras}',
			            		value: '{reserva.tipoArrasCodigo}'
			            	}
				        },		                
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.envio'),
		                	bind:		'{reserva.fechaEnvio}'
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe'),
		                	bind:		'{reserva.importe}'
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado.reserva'),
		                	bind:		'{reserva.estadoReservaDescripcion}'
		                },
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.firma'),
		                	bind:		'{reserva.fechaFirma}'		                		
		                },
		                {		                
		                	xtype: 'checkboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.reserva.con.impuesto'),
		                	readOnly: true,
		                	bind:		'{reserva.conImpuesto}'		                
		                },
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.vencimiento'),
		                	bind:		'{reserva.fechaVencimiento}'		                		
		                }		               
		        ]
			},
			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.reserva.anulacion'),
				items :
					[
		                {
		                	xtype:'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.motivo.anulacion'),
		                	bind:		'{reserva.motivoAnulacion}',
		                	readOnly: true
		                },
		                {
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.anulacion'),
		                	bind:		'{reserva.fechaAnulacion}',
		                	readOnly: true
		                }	
		                
		            ]
			},
			{
				
            	xtype: 'fieldset',
            	title:  HreRem.i18n('title.historico.entregas.a.cuenta'),
            	items : [
                	{
					    xtype		: 'gridBaseEditableRow',
					    topBar: true,
					    idPrincipal : 'expediente.id',
					    reference: 'listadoEntregasCuenta',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeEntregasACuenta}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('header.importe'),
					        	dataIndex: 'importe',
					        	flex: 1,
					        	editor: {
					        		xtype:'numberfield'
					        	}
					       },
						   {
					            text: HreRem.i18n('header.fecha.cobro'),
					            dataIndex: 'fechaCobro',
					            formatter: 'date("d/m/Y")',
					            flex: 1,
					            editor: {
					            	xtype: 'datefield',
					            	allowBlank: false
					            }
						   },
						   {
						   		text: HreRem.i18n('header.comprador'),
					            dataIndex: 'titular',
					            flex: 1,
					            editor: {
					            	xtype: 'textfield'
					            }
						   },						   
						   {
						   		text: HreRem.i18n('header.observacion'),
					            dataIndex: 'observaciones',
					            flex: 1,
					            editor: {
					            	xtype:'textarea'
					            }
						   }	
					    ]					    
					}
            	]
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);  
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});		
		
    }
});