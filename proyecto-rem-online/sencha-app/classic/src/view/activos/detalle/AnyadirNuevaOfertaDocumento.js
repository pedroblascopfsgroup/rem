Ext.define('HreRem.view.activos.detalle.AnyadirNuevaOfertaDocumento', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'anyadirnuevaofertadocumento',
	layout : 'fit',
	bodyStyle	: 'padding:20px',
	controller: 'activodetalle',

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
			}
			
			
		},
			
		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},
	    
	initComponent : function() {
		
		var titleAnyadir = null;
		var me = this;
		
		if(me.up().xtype.indexOf("wizardaltacomprador") >= 0){
			
		     var tipoExpedienteAlquiler = CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
		     var title = HreRem.i18n('wizard.comprador.title');
		     titleAnyadir = HreRem.i18n('title.nuevo.comprador');
		 

		     if(me.lookupViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteAlquiler){
			     title = HreRem.i18n('wizard.inquilino.title');
			    titleAnyadir =  HreRem.i18n('title.nuevo.inquilino');
		     };
		  
		     me.up().setTitle(title);
		  
			   
		}else {
			
			titleAnyadir = HreRem.i18n('title.nueva.oferta');
		}
		
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
			title: titleAnyadir,
			collapsible: false,
			items : [   {
				xtype: 'comboboxfieldbase',
	        	fieldLabel:  HreRem.i18n('fieldlabel.tipoDocumento'),
	        	name: 'comboTipoDocumento',
	        	allowBlank: false,
	        	docked: 'top',
	        	margin: '100px 0 0 150px',
	        	bind: {
            		store: '{comboTipoDocumento}'
            	}
			},
    	    {
				xtype:'textfieldbase',
				fieldLabel: HreRem.i18n('fieldlabel.documento.cliente'),
				margin: '10px 0 0 150px',
    	    	name:		'numDocumentoCliente',
    	    	allowBlank: false
    	    } ]
		} ];

		me.callParent();
	},
	
	resetWindow: function() {
    	var me = this;    	
    	me.setBindRecord(me.oferta);
	
    }
    

});