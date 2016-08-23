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
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
		                	bind:		'{datosbasicosoferta.tipoOfertaDescripcion}'		                		
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.notificacion'),
		                	bind:		'{datosbasicosoferta.fechaNotificacion}'
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.alta'),
		                	bind:		'{datosbasicosoferta.fechaAlta}'
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
		                	bind:		'{datosbasicosoferta.estadoDescripcion}'
		                },
		                {		                
		                	fieldLabel:  HreRem.i18n('fieldlabel.prescriptor'),
		                	bind:		'{datosbasicosoferta.prescriptorDescripcion}'		                
		                },
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.inicial.oferta'),
		                	bind:		'{datosbasicosoferta.importeOferta}'
		                },
		                {		                
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.contraoferta'),
		                	bind:		'{datosbasicosoferta.importeContraoferta}',
		                	colspan: 2
		                },
		                {
		                	xtype: 'fieldset',
		                	title:  HreRem.i18n('title.comite.sancionador'),
		                	colspan: 2,
		                	margin: '0 10 10 0',
		                	layout: 'hbox',
		                	items: [
					                	{
					                		xtype: 'button',
					                		text: HreRem.i18n('fieldlabel.verificar.comite'),
					                		margin: '0 10 0 0',
					                		disabled: true // TODO Comités sin definir
					                	},
					                	{
					                		xtype: 'displayfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.comite'),
					                		bind: {
					                			value : '{datosbasicosoferta.comite}'
					                		}   		
					                	}
					                	
		                	
		                	]
		                		
		                	
		                },
		                {
		                	xtype: 'fieldset',
		                	margin: '0 10 10 0',
		                	title:  HreRem.i18n('title.visita'),
		                	layout: 'hbox',
		                	items: [
					                	{
					                		xtype: 'button',
					                		text: HreRem.i18n('fieldlabel.asignar.visita'),
					                		margin: '0 10 0 0' 
					                	},
					                	{
					                		xtype: 'displayfieldbase',
					                		fieldLabel:  HreRem.i18n('fieldlabel.numero.visita'),
					                		bind: {
					                			value : '{datosbasicosoferta.numVisita}'
					                		}   		
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
					    topBar: true,
					    reference: 'listadoTextosOferta',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeTextosOferta}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('header.campo'),
					        	dataIndex: 'campoDescripcion',
					        	flex: 1,
					        	editor: {
						        		xtype: 'combobox',
						        		cls: 'grid-no-seleccionable-field-editor',
						        		store: Ext.create('Ext.data.Store',{								        		
						        			model: 'HreRem.model.ComboBase',
											proxy: {
												type: 'uxproxy',
												remoteUrl: 'generic/getDiccionario',
												extraParams: {diccionario: 'tiposTextoOferta'}
											},
											autoLoad: true
										}),								            	
						            	displayField: 'descripcion',
										valueField: 'codigo'    											
								}
					       },
						   {
					            text: HreRem.i18n('header.texto'),
					            dataIndex: 'texto',
					            flex: 4,
					            editor: {
			       					xtype:'textarea'
					       		}
							}
					       	        
					    ],
			           
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeTextosOferta}'
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
    }
});