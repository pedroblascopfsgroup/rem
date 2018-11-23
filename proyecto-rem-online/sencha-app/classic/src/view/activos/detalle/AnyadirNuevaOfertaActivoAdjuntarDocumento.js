Ext.define('HreRem.view.activos.detalle.AnyadirNuevaOfertaActivoAdjuntarDocumento', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevaofertaactivoadjuntardocumento',
    layout		: 'fit',
    //closable	: true,		
    //closeAction	: 'hide',
    bodyStyle	: 'padding:10px',
    
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    recordName	: "oferta",						
    recordClass	: "HreRem.model.OfertaComercial",
    
    requires: ['HreRem.view.activos.detalle.DocumentosActivoOfertaComercial'],
    
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
    	
    	//me.setTitle(HreRem.i18n('title.nueva.oferta'));
    	
    	me.buttons = [ {itemId: 'btnAtras', text: 'Volver', handler: 'onClickBotonCancelarOferta'},
    		{ itemId: 'btnGenerarDoc', text: 'Generar Documento', handler: 'onClickBotonCancelarOferta'},
    		{ itemId: 'btnSubirDoc', text: 'Subir Documento', handler: 'abrirFormularioAdjuntarDocumentos'},
    		{ itemId: 'btnFinalizar', text: 'Finalizar', handler: 'onClickBotonCancelarOferta'}];
    	
    	me.items = [
    		{
    			xtype:'fieldsettable',
				layout:'vbox',
				defaultType: 'container',
		        //title: HreRem.i18n('title.informacion.general'),
				items :
					[
						{
							xtype:'checkboxfieldbase',
							fieldLabel: 'Cesi&oacute;n datos a haya',//HreRem.i18n('fieldlabel.perimetro.check.admision'),
							bind:		'{oferta.cesionDatosHaya}',
							reference: 'chkbxCesionDatosHaya',
							readOnly: false
						},
						{
							xtype:'checkboxfieldbase',
							fieldLabel: 'Comuncacion a terceros',//HreRem.i18n('fieldlabel.perimetro.check.admision'),
							bind:		'{oferta.comunicacionTerceros}',
							reference: 'chkbxcComunicacionTerceros',
							readOnly: false
						},
						{
							xtype:'checkboxfieldbase',
							fieldLabel: 'Transferencias internacionales',//HreRem.i18n('fieldlabel.perimetro.check.admision'),
							bind:		'{oferta.transferenciasInternacionales}',
							reference: 'chkbxTransferenciasInternacionales',
							readOnly: false
						},
			    		{
			    			xtype: 'documentosactivoofertacomercial'
			    		}
					]
    		}
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		//form.setBindRecord(me.oferta);
	
    }
    
});