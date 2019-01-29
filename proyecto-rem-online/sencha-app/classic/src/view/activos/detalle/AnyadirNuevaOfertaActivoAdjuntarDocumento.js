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
    			layout["prev"]();
    		}
    	},
    		{ itemId: 'btnGenerarDoc', text: 'Generar Documento', handler: 'onClickBotonGenerarDoc', disabled: true},
    		{ itemId: 'btnSubirDoc', text: 'Subir Documento', handler: 'abrirFormularioAdjuntarDocumentoOferta', disabled: false},
    		{ itemId: 'btnFinalizar', text: 'Finalizar', handler: 'onClickCrearOferta', disabled: false}];
    	
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
							bind:		'{oferta.cesionDatosHaya}',
							name:       'cesionDatos',
							margin: '50px 0 0 200px',
							reference: 'chkbxCesionDatosHaya',
							readOnly: false,
							listeners: {
	                              change: function (checkbox, newVal, oldVal) {
	                            	  var esInternacional = checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('carteraInternacional').getValue();
	                            	  var checkTransInternacionales = checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('transferenciasInternacionales').getValue();
	                            	  if(checkbox.getValue()) {
	                            		  if(esInternacional) {
	                            			  if(checkTransInternacionales) {
	                            				  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').enable();
	                            			  } else {
	                            				  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').disable();
	                            			  }
	                            			  
	                            		  } else {
	                            			  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').enable();
	                            		  }
	                            	  } else {
	                            		  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').disable();
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
							bind:		'{oferta.transferenciasInternacionales}',
							name:       'transferenciasInternacionales',
							margin: '10px 0 0 200px',
							reference: 'chkbxTransferenciasInternacionales',
							readOnly: false,
							listeners: {
	                              change: function (checkbox, newVal, oldVal) {
	                            	  var esInternacional = checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('carteraInternacional').getValue();
	                            	  var checkCesionDatos = checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('cesionDatos').getValue();
	                            	  if(checkbox.getValue() && esInternacional && checkCesionDatos)
	                            		  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').enable();
	                            	  else if (checkbox.getValue() && !esInternacional && checkCesionDatos)
	                            		  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').enable();
	                            	  else if (!checkbox.getValue() && !esInternacional && checkCesionDatos)
	                            		  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').enable();
	                            	  else
	                            		  checkbox.up('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').disable();
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