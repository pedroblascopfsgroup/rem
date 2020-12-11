Ext.define('HreRem.view.activos.detalle.CrearEvolucionObservaciones', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'crearevolucionobservacioneswindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.75,    
    height	: Ext.Element.getViewportHeight() > 700 ? 310 : Ext.Element.getViewportHeight() - 490,
	reference: 'crearevolucionobservacioneswindowref',
    controller: 'activodetalle',
    
    viewModel: {
        type: 'activodetalle'
    },
    
    requires: ['HreRem.model.ActivoEvolucion', 'HreRem.view.activos.detalle.ActivoDetalleModel'],
       
    observacionesAdmision: null,   
    
	listeners: {
	
		show: function() {	
			var me = this;
			me.resetWindow();			
		}

	},
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n('fieldlabel.historico.tramitacion.titulo.observaciones'));
    	
    	me.buttonAlign = 'center'; 
    	
    	me.buttons = [ { itemId: 'btnOk', text: HreRem.i18n('btn.salto.tarea.cerrar'), handler: 'onClickCerrarObservacionesEvolucion'}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	    				reference: 'formEstadoAdmision',
	   			 		
	    				cls:'',	    				
					    recordName: "evolucion",
						
						recordClass: "HreRem.model.ActivoEvolucion",
						defaults: {
									padding: 10
								},
    					items: [
    						{ 
					        	xtype: 'textareafieldbase',
					        	scrollable	: 'y',
					        	readOnly: true,
								reference: 'observacionesAdmisionRef',
								width: 		'100%',
								colspan: 1,
					        	bind: {
				            		value: me.observacionesAdmision
				            	}
					        }
					        
					]
    			}
    	]
		
    	me.callParent();
    	
    },
    
    resetWindow: function() {

    	var me = this,    	
    	form = me.down('formBase');     			
		form.setBindRecord(form.getModelInstance());
		form.reset();
		me.lookupReference('observacionesAdmisionRef').setValue(me.observacionesAdmision);
	
    }


});