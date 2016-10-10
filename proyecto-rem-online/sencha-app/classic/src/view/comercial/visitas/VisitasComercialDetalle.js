Ext.define('HreRem.view.comercial.visitas.VisitasComercialDetalle', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'visitascomercialdetalle',
    reference	: 'windowVisitaComercialDetalle',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 2,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    //closable: true,		
    //closeAction: 'hide',
    
    idTrabajo: null,
    
    parent: null,
    
    detallevisita: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    detallevisita: null,
    
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    
	
    
    listeners: {    
		boxready: function(window) {
			var me = this;
			
			Ext.Array.each(window.down('fieldset').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
		},
				
		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},
    
	initComponent: function() {
    	var me = this;
    	me.buttons = [ { itemId: 'btnCerrar', text: 'Cerrar', handler: 'onClickBotonCerrarDetalleVisita'}];
    	var detallevisita= me.detallevisita.data;
    	me.items = [
			{
			    xtype: 'formBase',
			    reference: 'formVisitasComercialDetalle',
			    
			    items: [
			    	{

		        		xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'textfield',
						cls	: 'panel-base shadow-panel',
						layout: 'column',
						title: HreRem.i18n('header.visita.detalle.datos.solicitante'),
					
							items :
								[
								 	{ 
										fieldLabel: HreRem.i18n('header.visita.detalle.fecha.solicitud.visita'),
										xtype: 'datefieldbase',
										bind: '{detallevisita.fechaSolicitud}',
										readOnly: true
									},
									{ 
										fieldLabel: HreRem.i18n('header.visita.detalle.solicitante'),
										xtype: 'textfieldbase',
										bind: '{detallevisita.nombreCompleroCliente}',
										readOnly: true
									},
									{ 
										fieldLabel: HreRem.i18n('header.visita.detalle.nif.solicitante'),
										xtype: 'textfieldbase',
										bind: '{detallevisita.documentoCliente}',
										readOnly: true
									},
									{ 
										fieldLabel: HreRem.i18n('header.visita.detalle.telefono.solicitante'),
										xtype: 'numberfieldbase',
										bind: '{detallevisita.telefono1Cliente}',
										readOnly: true
									},
									{ 
										fieldLabel: HreRem.i18n('header.visita.detalle.email.solicitante'),
										xtype: 'textfieldbase',
										bind: '{detallevisita.emailCliente}',
										readOnly: true
									}
								 ]
			    		},
			    		{

		        		xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'textfield',
						cls	: 'panel-base shadow-panel',
						layout: 'column',
						title: HreRem.i18n('header.visita.detalle.datos.visita'),
					
							items :
								[
									{
						        		xtype:'datefieldbase',
						        		fieldLabel: HreRem.i18n('header.visita.detalle.fecha.contactoCliente'),
										formatter: 'date("d/m/Y")',
										bind: '{detallevisita.fechaContacto}',
							        	readOnly: true
							        },
							        
								 	{ 
										xtype: 'textfieldbase',
					                	fieldLabel:  HreRem.i18n('header.visita.detalle.estado.visita'),
					                	bind: '{detallevisita.estadoVisitaDescripcion}',
				    					readOnly: true
							        },
							        { 
										xtype: 'textfieldbase',
					                	fieldLabel:  HreRem.i18n('header.visita.detalle.subestado.visita'),
					                	bind: '{detallevisita.subEstadoVisitaDescripcion}',
				    					readOnly: true
							        },
							        {
						        		xtype:'datefieldbase',
						        		fieldLabel: HreRem.i18n('header.visita.detalle.fecha.visita.concertada'),
										formatter: 'date("d/m/Y")',
										bind: '{detallevisita.fechaConcertacion}',
							        	readOnly: true
							        },
//							        {
//						        		xtype:'datefieldbase',
//						        		fieldLabel: HreRem.i18n('header.visita.detalle.fecha.finalizacion'),
//										formatter: 'date("d/m/Y")',
//										bind: '{detallevisita.fechaFinalizacion}',
//							        	readOnly: true
//							        },
//							        { 
//										fieldLabel: HreRem.i18n('header.visita.detalle.motivo.finalizacion'),
//										xtype: 'textfieldbase',
//										bind: '{detallevisita.motivoFinalizacion}',
//										readOnly: true
//									},
									{ 
										fieldLabel: HreRem.i18n('header.visita.detalle.observaciones'),
										xtype: 'textareafieldbase',
										bind: '{detallevisita.observacionesVisita}',
										readOnly: true
									}
							        
							        
								 ]
			    		}
			    		
			    		
			    		
			    		
			    		
			    		
			    		
			    	]
					
    	}		
				
    	];
    	
    	var title= "Número del activo: "+detallevisita.numActivo+"<br/>" +" Número de la visita: "+detallevisita.numVisita;
    	
    	me.callParent();
    	me.setTitle(title);
    },
    
    resetWindow: function() {
		var me = this;
    	me.getViewModel().set('detallevisita', me.detallevisita);
	
    }
    
});