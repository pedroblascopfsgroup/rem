Ext.define('HreRem.view.expedientes.DatosBasicosOferta', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosoferta',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosoferta',
    scrollable	: 'y',

	recordName: "datosbasicosoferta",
	
	recordClass: "HreRem.model.DatosBasicosOferta",
    
    requires: ['HreRem.model.DatosBasicosOferta'],
    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.datos.basicos.oferta'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.oferta'),
				items :
					[
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.oferta'),
		                	bind:		'{datosbasicosoferta.numOferta}'

		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	readOnly: true,
		                	bind: {
								store: '{comboTipoOferta}',
								value: '{datosbasicosoferta.tipoOfertaCodigo}'
							},
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo')
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.alta'),
		                	bind:		'{datosbasicosoferta.fechaAlta}'
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{comboEstadoOferta}',
								value: '{datosbasicosoferta.estadoCodigo}'
							},
							readOnly: true,
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado')
		                },
		                {	
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.prescriptor'),
		                	bind: {
								value: '{datosbasicosoferta.prescriptor}'
							},
							readOnly: true
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.canal.prescripcion'),
		                	bind: {
								store: '{comboCanalPrescripcion}',
								value: '{datosbasicosoferta.canalPrescripcionCodigo}'
							},
							editable: true
		                },
		                {
		                	xtype: 'numberfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.inicial.oferta'),
		                	bind:		'{datosbasicosoferta.importeOferta}'
		                },
		                {	
		                	xtype: 'numberfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.contraoferta'),
		                	bind:		{
		                		value: '{datosbasicosoferta.importeContraOferta}',
		                		disabled: '{esCarteraSareb}'
		                	},
		                	colspan: 2
		                },

		                {
		                	xtype: 'fieldset',
		                	title:  HreRem.i18n('title.comite.sancionador'),
		                	colspan: 2,
		                	margin: '0 10 10 0',
		                	height: 90,
		                	layout: 'vbox',
		                	items: [
						                {
						                	xtype: 'comboboxfieldbase',
						                	fieldLabel:  HreRem.i18n('fieldlabel.comite.seleccionado'),
						                	reference: 'comboComiteSeleccionado',
						                	bind: {
												store: '{comboComites}',
												value: '{datosbasicosoferta.comiteSancionadorCodigo}'
											}
						                },
						                {
						                	xtype: 'container',
						                	bind: { 
						                		hidden: '{!esCarteraBankia}'
						                	},
						                	layout: 'hbox',
						                	items: [
						                	    
								                {
								                	xtype: 'comboboxfieldbase',
								                	fieldLabel:  HreRem.i18n('fieldlabel.comite.propuesto'),
								                	reference: 'comboComitePropuesto',
								                	readOnly: true,								                	
								                	bind: {
														store: '{comboComites}',
														value: '{datosbasicosoferta.comitePropuestoCodigo}',
														hidden: '{!datosbasicosoferta.comitePropuestoCodigo}'
													}
								                },
								                {
							                		xtype: 'button',
							                		text: HreRem.i18n('btn.consultar.comite'),
							                		handler: 'consultarComiteSancionador',
							                		margin: '0 40 0 0'
					                			}
						                	]
						                	
						                }

		                	]
		                		
		                	
		                },
		                {
		                	xtype: 'fieldset',
		                	margin: '0 10 10 0',
		                	height: 90,
		                	title:  HreRem.i18n('title.visita'),
		                	layout: 'vbox',
		                	items: [
										{ 
											xtype: 'comboboxfieldbase',
											reference: 'comboEstadosVisita',
								        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
								        	bind: {
							            		store: '{comboEstadosVisitaOferta}',
							            		value: '{datosbasicosoferta.estadoVisitaOfertaCodigo}'
							            	}
								        },	
		                				{
		                					xtype: 'container',
		                					layout: 'hbox',
			                				items: [
							                	{
							                		xtype: 'button',
							                		text: HreRem.i18n('fieldlabel.asignar.visita'),
							                		margin: '0 10 0 0',
							                		hidden: true
							                		
							                	},
							                	{
							                		xtype: 'numberfieldbase',
							                		fieldLabel:  HreRem.i18n('fieldlabel.numero.visita'),
							                		bind: {
							                			value : '{datosbasicosoferta.numVisita}'
							                		}   		
							                	}
							                ]
			                			}
		                	]
		                		
		                	
		                }
		        ]
			},
			{
				
            	xtype: 'fieldset',
            	title:  HreRem.i18n('title.textos'),
            	items : [
                	{
					    xtype		: 'gridBaseEditableRow',
					    idPrincipal : 'expediente.id',
					    topBar: false,
					    reference: 'listadoTextosOferta',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeTextosOferta}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('header.campo'),
					        	dataIndex: 'campoDescripcion',
					        	flex: 1
					       },
						   {
					            text: HreRem.i18n('header.texto'),
					            dataIndex: 'texto',
					            flex: 4,
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