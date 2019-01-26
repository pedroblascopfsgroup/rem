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
    		{ itemId: 'btnGenerarDoc', text: 'Generar Documento', handler: 'onClickBotonGenerarDoc'},
    		{ itemId: 'btnSubirDoc', text: 'Subir Documento', handler: 'abrirFormularioAdjuntarDocumentoOferta'},
    		{ itemId: 'btnFinalizar', text: 'Finalizar', handler: 'onClickCrearOferta'}];
    	
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
							xtype:'checkboxfieldbase',
							fieldLabel: HreRem.i18n('wizard.oferta.documento.cesionDatos'),							
							bind:		'{oferta.cesionDatosHaya}',
							name:       'cesionDatos',
							margin: '50px 0 0 200px',
							reference: 'chkbxCesionDatosHaya',
							readOnly: false
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
							readOnly: false
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
				    	        	 id: 'docOfertaComercial',
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