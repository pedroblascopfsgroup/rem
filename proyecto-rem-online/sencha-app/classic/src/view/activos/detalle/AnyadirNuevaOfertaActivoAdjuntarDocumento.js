Ext.define('HreRem.view.activos.detalle.AnyadirNuevaOfertaActivoAdjuntarDocumento', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevaofertaactivoadjuntardocumento',
    layout		: 'fit',
    bodyStyle	: 'padding:20px',
    controller: 'activodetalle',

    recordName	: "oferta",						
    recordClass	: "HreRem.model.OfertaComercial",
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

    	me.buttons = [ {
    		itemId: 'btnAtras',
    		text: 'Volver',
    		handler: function(btn){
    			var wizard = btn.up().up().up();
    			var layout = wizard.getLayout();
    			var ventanaWizard = btn.up('anyadirnuevaofertaactivoadjuntardocumento'),
    			btnGenerarDoc = ventanaWizard.down('button[itemId=btnGenerarDoc]');
    			if(wizard.xtype.indexOf('wizardaltacomprador') >= 0) {
        			wizard.height = Ext.Element.getViewportHeight() > 800 ? 800 : Ext.Element.getViewportHeight()-100;
        			wizard.setY( Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 800 ? 800 : Ext.Element.getViewportHeight() -100)/2));
        			wizard.width= Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5;
        			wizard.setX( Ext.Element.getViewportWidth() / 2 - ((Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5) / 2));
    			} else {
    				wizard.width= Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5;
    				wizard.setX( Ext.Element.getViewportWidth() / 2 - ((Ext.Element.getViewportWidth() > 1370 ? Ext.Element.getViewportWidth() / 2 : Ext.Element.getViewportWidth() /1.5) / 2));
    				wizard.height = Ext.Element.getViewportHeight() > 600 ? 600 : Ext.Element.getViewportHeight() -100;
		    		wizard.setY( Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 600 ? 600 : Ext.Element.getViewportHeight() -100)/2));
    			}
    			
    			var esInternacional = ventanaWizard.getForm().findField('carteraInternacional').getValue();
          	    var cesionDatos = ventanaWizard.getForm().findField('cesionDatos').getValue();
          	    var checkTransInternacionales = ventanaWizard.getForm().findField('transferenciasInternacionales').getValue();
          	  
    			if(cesionDatos) {
	          		  if(esInternacional) {
	          			  if(checkTransInternacionales)
	          				btnGenerarDoc.enable();
	          			  else 
	          				btnGenerarDoc.disable();
	          		  } else {
	          			btnGenerarDoc.enable();
	          		  }
	          	  } else {
		          	btn.enable();
	          		btnGenerarDoc.disable();
	          		ventanaWizard.getForm().findField('comunicacionTerceros').enable();
	          		ventanaWizard.getForm().findField('transferenciasInternacionales').enable();
	          	  }
    			
    			wizard.down('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnSubirDoc]').disable();
    			wizard.down('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnFinalizar]').disable();
    			
    			layout["prev"]();
    		}
    	},
    		{ itemId: 'btnGenerarDoc', text: 'Generar Documento', handler: 'onClickBotonGenerarDoc', disabled: true},
    		{ itemId: 'btnSubirDoc', text: 'Subir Documento', handler: 'abrirFormularioAdjuntarDocumentoOferta', disabled: true},
    		{ itemId: 'btnFinalizar', text: 'Finalizar', handler: 'onClickCrearOferta', disabled: true}];
    	
    	me.items = [
    		{
    			xtype:'fieldsettable',
				layout:'vbox',
				defaultType: 'container',
				collapsible: false,
				title: HreRem.i18n('fieldset.title.doc'),
				items :
					[
						{
							xtype: 'checkboxfieldbase',
							name: 'carteraInternacional',
							hidden: true
						},
						{
							xtype:'checkboxfieldbase',
							fieldLabel: HreRem.i18n('wizard.oferta.documento.cesionDatos'),							
							bind:  '{oferta.cesionDatosHaya}',
							name:       'cesionDatos',
							margin: '50px 0 0 200px',
							reference: 'chkbxCesionDatosHaya',
							readOnly: false,
							listeners: {
	                              change: function (checkbox, newVal, oldVal) {
	                            	  var ventanaWizard = checkbox.up('anyadirnuevaofertaactivoadjuntardocumento'),
	                            	  esInternacional = ventanaWizard.getForm().findField('carteraInternacional').getValue(),
	                            	  btnGenerarDoc = ventanaWizard.down('button[itemId=btnGenerarDoc]'),
	                            	  btnSubirDoc = ventanaWizard.down('button[itemId=btnSubirDoc]'),
	                            	  btnFinalizar = ventanaWizard.down('button[itemId=btnFinalizar]');
	                            	  if(checkbox.getValue()) {
	                            		  if(esInternacional) {
	                            			  if(checkTransInternacionales) {
	                            				  btnGenerarDoc.enable();
	                            			  } else {
	                            				  btnGenerarDoc.disable();
	                            			  	  btnSubirDoc.disable();
	                            			  }
	                            		  } else {
	                            			  btnGenerarDoc.enable();
	                            		  }
	                            	  } else {
	                            		  checkbox.enable();
	                            		  btnGenerarDoc.disable();
	                            		  btnSubirDoc.disable();
	                            		  btnFinalizar.disable();
	                            		  ventanaWizard.getForm().findField('comunicacionTerceros').enable();
	                            		  ventanaWizard.getForm().findField('transferenciasInternacionales').enable();
	                            	  }
	                              }
	                          }
						},
						{
							xtype:'checkboxfieldbase',
							fieldLabel: HreRem.i18n('wizard.oferta.documento.comunicacionTerceros'),
							bind:		'{oferta.comunicacionTerceros}',
							name:       'comunicacionTerceros',
							margin: '10px 0 0 200px',
							reference: 'chkbxcComunicacionTerceros',
							readOnly: false
						},
						{
							xtype:'checkboxfieldbase',
							fieldLabel: HreRem.i18n('wizard.oferta.documento.transferenciasInternacionales'),
							bind:	'{oferta.transferenciasInternacionales}',
							name:       'transferenciasInternacionales',
							margin: '10px 0 0 200px',
							reference: 'chkbxTransferenciasInternacionales',
							readOnly: false,
							listeners: {
	                              change: function (checkbox, newVal, oldVal) {
	                            	  var ventanaWizard = checkbox.up('anyadirnuevaofertaactivoadjuntardocumento'),
	                            	  esInternacional = ventanaWizard.getForm().findField('carteraInternacional').getValue(),
	                            	  btnGenerarDoc = ventanaWizard.down('button[itemId=btnGenerarDoc]'),
	                            	  cesionDatos = ventanaWizard.getForm().findField('cesionDatos').getValue(),
	                            	  btnSubirDoc = ventanaWizard.down('button[itemId=btnSubirDoc]'),
	                            	  btnFinalizar = ventanaWizard.down('button[itemId=btnFinalizar]');
	                            	  
	                            	  if(checkbox.getValue() && esInternacional && cesionDatos) {
	                            		  btnGenerarDoc.enable();
	                            	  } else if (checkbox.getValue() && !esInternacional && cesionDatos) {
	                            		  btnGenerarDoc.enable();
	                            	  } else if (!checkbox.getValue() && !esInternacional && cesionDatos) {
	                            		  btnGenerarDoc.enable();
	                            	  } else {
	                            		  btnGenerarDoc.disable();
	                            		  btnSubirDoc.disable();
	                            		  btnFinalizar.disable();
	                            	  }
	                              }
	                          }
						},
			    		{
							xtype: 'panel',
							layout: 'hbox',
							name : 'panelDocumentoOferta',
							margin: '10px 0 0 200px',
							style : 'background-color: transparent; border: none;',
							title: HreRem.i18n('title.documentos'),
							cls: 'panel-base',
							items: [
				    	         {
				    	        	 xtype: 'textfieldbase',
				    	        	 name: 'docOfertaComercial',
				    	        	 readOnly: true,
				    	        	 padding: 10,
				    	        	 style: 'overflow: hidden',
				    	        	 listeners: {
				    	        		 render: function(text){
				    	        			 
				    	        			var tip = Ext.create('Ext.tip.Tip', {
				    	        		    	    html: ''
				    	        		    });
				    	        			 
				    	        			 text.getEl().on('mouseover', function(){
				    	        				 tip.setHtml(text.value);
				    	        				 if(!Ext.isEmpty(tip.html)){
				    	        					 tip.showAt(text.getEl().getX()-10,text.getEl().getY()+45);
				    	        				 }
				    	        	         });
				    	        			 
				    	        			 text.getEl().on('mouseleave', function(){
				    	        				 tip.hide();
				    	        	         });
				    	        			 
				    	        		 }
				    	        	 }
				    	         },{
				    	        	 xtype:'button',
				    	        	 iconCls: 'fa fa-trash',
				    	        	 margin: '10px 0 0 0',
				    	        	 itemId: 'btnBorrarDoc',
				    	        	 style:'bodyBackground: transparent',
				    	        	 hidden : true,
					        		 handler: 'borrarDocumentoAdjuntoOferta'
				    	         }
				    	    ]
				    	}

					]
    		}
    	];
    	
    	me.callParent();

    },
    
    resetWindow: function() {
    	var me = this;   	
		me.setBindRecord(me.oferta);
	
    }
    
});