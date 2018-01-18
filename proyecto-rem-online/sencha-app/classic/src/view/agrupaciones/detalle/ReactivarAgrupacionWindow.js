Ext.define('HreRem.view.agrupaciones.detalle.ReactivarAgrupacionWindow', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'reactivarAgrupacionWindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
    reference: 'reactivarAgrupacionWindowRef',
    requires: ['HreRem.model.VigenciaAgrupacion'],
    
    idAgrupacion: null,
    fechaFinVigenciaActual:null,
    parent: null,
    
    listeners: {

		boxready: function(window) {
			
			var me = this;
			form = me.down('formBase');
			form.setBindRecord(Ext.create('HreRem.model.VigenciaAgrupacion'));
			
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
		}
    },

    initComponent: function() {

    	var me = this;

    	me.setTitle(HreRem.i18n('title.reactivar.agrupacion'));

    	me.buttonAlign = 'left';

    	

    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Reactivar', handler: 'onClickBotonReactivar', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase',
	    				url: $AC.getRemoteUrl("agrupacion/reactivar"),
	    				reference: 'adjuntarDocumentoFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	   			 		recordName: "agrupacion",	
	    				cls:'formbase_no_shadow',
	    				items: [
				    			{
							    	xtype: 'label',
							    	html: '<span class="title-aviso-red">'+HreRem.i18n('txt.aviso').toUpperCase()+'</span><br><span>'+HreRem.i18n('info.reactivar')+'</span><br><br>' 
							    },
	    						{
									xtype : 'datefieldbase',
									fieldLabel : HreRem.i18n('header.fecha.inicio.vigencia'),
									readOnly: false,
									name: 'fechaInicioVigencia',
									allowBlank: false,
									bind:{
										value: '{agrupacion.fechaInicioVigencia}',
										maxValue: '{agrupacion.fechaFinVigencia}'
									}
								}, 
								{
									xtype : 'datefieldbase',
									fieldLabel : HreRem.i18n('header.fecha.fin.vigencia'),
									maxValue : null,
									readOnly: false,
									name: 'fechaFinVigencia',
									allowBlank: false,
									bind:{
										value: '{agrupacion.fechaFinVigencia}',
										minValue: '{agrupacion.fechaInicioVigencia}'
									}
									
								}
						]
				}
    	];

    	me.callParent();
    },

    onClickBotonReactivar: function(btn) {

    	var me = this,
    	form = me.down("form");
    	var window = btn.up('window');
    	if(form.isValid()){
    		window.mask(HreRem.i18n("msg.mask.loading"));
    		form.getBindRecord().save({
				params: {
                    idAgrupacion: me.idAgrupacion
                },
		   		success: function (a, operation) {
		   			if(Ext.decode(operation.getResponse().responseText).errorCode!=null){
		   				me.fireEvent("errorToast", HreRem.i18n(Ext.decode(operation.getResponse().responseText).errorCode));
		   				window.unmask();
		   				window.close();
		   			}else{
		   				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			   			window.unmask();
    		    		window.close();
    		    		window.up('form').funcionRecargar();
		   			}
		   			
    		    	
		   		},		   		          
		   		failure: function(a, operation) {
		   			Utils.defaultOperationFailure(a, operation, form);
		   		}
		   	});

           
        }



    }
});
