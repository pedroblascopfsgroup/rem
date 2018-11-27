Ext.define('HreRem.view.activos.detalle.AnyadirNuevaOfertaDocumento', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'anyadirnuevaofertadocumento',
	layout : 'fit',
	recordName: "oferta",						
	recordClass: "HreRem.model.OfertaComercial",
	
	
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
	    
	initComponent : function() {

		var me = this;

		// me.setTitle(HreRem.i18n('title.nueva.oferta'));

		me.buttons = [ {
			itemId : 'btnAvanza',
			text : 'Continuar',
			handler : function(btn){
				var wizard = btn.up().up().up();
				var layout = wizard.getLayout();
				layout["next"]();
			}
		} ],

		me.items = [ {
			xtype : 'fieldsettable',
			layout : 'vbox',
			defaultType : 'container',
			// title: HreRem.i18n('title.informacion.general'),
			items : [   {
				xtype: 'comboboxfieldbase',
	        	fieldLabel:  HreRem.i18n('fieldlabel.tipoDocumento'),
	        	itemId: 'comboTipoDocumento',
	        	allowBlank: false,
	        	docked: 'top',
	        	bind: {
            		store: '{comboTipoDocumento}',
            		value: '{oferta.tipoDocumento}'
            	},
            	displayField: 'descripcion',
				valueField: 'codigo'
			},
    	    {
				xtype:'textfieldbase',
				fieldLabel: HreRem.i18n('fieldlabel.documento.cliente'),
				margin: '40px 40px 0 0px',
    	    	name:		'numDocumentoCliente',
    	    	allowBlank: false,
				bind:		'{oferta.numDocumentoCliente}'
    	    } ]
		} ];

		me.callParent();
	},
	
	resetWindow: function() {
    	var me = this;    	
    	me.setBindRecord(me.oferta);
	
    }

});