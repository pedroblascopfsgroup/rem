Ext.define('HreRem.view.activos.detalle.AnyadirNuevaOfertaDocumento', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'anyadirnuevaofertadocumento',
	layout : 'fit',
	bodyStyle	: 'padding:20px',
	recordName: "oferta",						
	recordClass: "HreRem.model.FichaComprador",
	controller: 'activodetalle',
	viewModel: {
		type: 'activodetalle'
	},
	requires: ['HreRem.model.OfertaComercial'],
	listeners: {    
		boxready: function(window) {
			var me = this;
			
			var wizard = me.up();
			
			Ext.Array.each(window.down('fieldset').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
			
			if(wizard.xtype.indexOf("wizardaltacomprador") >= 0){
				window.setViewModel(me.up('wizardaltacomprador').down('datoscompradorwizard').getViewModel());
				//window.setBindRecord(Ext.create('HreRem.model.FichaComprador'));
			}
			
			
		},
			
		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},
	    
	initComponent : function() {

		var me = this;		
		
		me.buttons = [ {
			itemId : 'btnAvanza',
			text : 'Continuar',
			handler : 'existeCliente'
		},
		{
			itemId : 'btnCancelar',
			text : 'Cancelar',
			handler : 'onClickBotonCancelarWizard'	
		}],

		me.items = [ {
			xtype : 'fieldsettable',
			layout : 'vbox',
			defaultType : 'container',
			title:  HreRem.i18n('title.nueva.oferta'),
			collapsible: false,
			items : [   {
				xtype: 'comboboxfieldbase',
	        	fieldLabel:  HreRem.i18n('fieldlabel.tipoDocumento'),
	        	itemId: 'comboTipoDocumento',
	        	name: 'comboTipoDocumento',
	        	allowBlank: false,
	        	docked: 'top',
	        	margin: '100px 0 0 150px',
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
				margin: '10px 0 0 150px',
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