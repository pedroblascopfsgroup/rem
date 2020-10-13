Ext.define('HreRem.view.activos.detalle.AnyadirComplementoTitulo', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadircomplementotitulo',
    layout	: 'fit',
    /*width	: Ext.Element.getViewportWidth() / 3,*/    
    /*height	: Ext.Element.getViewportHeight() / 3,*/

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    idActivo: null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		},
		boxready: function(window) {
			var me = this;
			//me.initWindow();
		}
		
	},
	
	/*initWindow: function() {
    	var me = this;
    	
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
			);
    	}
    	
    },*/

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n("title.anyadir.complemento.titulo"));
    	
    	me.buttons = [ { itemId: 'btnAnyadir', text: HreRem.i18n('itemSelector.btn.add.tooltip'), handler: 'onClickBotonAnyadirComplementoTitulo'}, 
    		{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarVentanaComplementoTitulo'}];
    	
    	me.items = [
				{
					xtype: 'formBase', 
					collapsed: false,
					layout: {
						type: 'table',
				        // The total column count must be specified here
				        columns: 1,
				        trAttrs: {height: '30px', width: '100%'},
				        tdAttrs: {width: '100%'},
				        tableAttrs: {
				            style: {
				                width: '100%'
								}
				        }
    				},
   			 		cls:'formbase_no_shadow',
   			 		defaults: {
   			 			width: '100%',
   			 			msgTarget: 'side',
   			 			addUxReadOnlyEditFieldPlugin: false
   			 		},			
					
					items: [
					
						{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('header.complemento.titulo.tipo'),
				        	reference: 'comboTipoTituloRef',
				        	name: 'comboTipoTituloComplemento',
			            	bind: {
			            		store: '{storeTipoTituloComplemento}'
			            	},
			            	width: '400px',
							publishes: 'value',									
    						allowBlank: false
			    		},
			    		{ 
							xtype: 'datefieldbase',
							reference: 'fechaSolicitudRef',
							formatter: 'date("d/m/Y")',
				        	fieldLabel:  HreRem.i18n('header.complemento.titulo.fecha.solicitud'),	
				        	width: '400px',
				        	name: 'fechasolicitud'
			    		},
			    		{
		                	xtype: 'datefieldbase',
		                	reference: 'fechaTituloRef',
							formatter: 'date("d/m/Y")',
				        	fieldLabel:  HreRem.i18n('header.complemento.titulo.fecha'),	
				        	width: '400px',
				        	name: 'fechatitulo'
	            		},
	            		{
		                	xtype: 'datefieldbase',
							formatter: 'date("d/m/Y")',
							reference: 'fechaRecepcionRef',
				        	fieldLabel:  HreRem.i18n('header.complemento.titulo.fecha.recepcion'),	
				        	width: '400px',
				        	name: 'fecharecepcion'
	            		},
	            		{
		                	xtype: 'datefieldbase',
							formatter: 'date("d/m/Y")',
							reference: 'fechaInscripcionRef',
				        	fieldLabel:  HreRem.i18n('header.complemento.titulo.fecha.inscripcion'),
				        	width: '400px',
				        	name: 'fechainscripcion'
	            		},
	            		{
		                	xtype: 'textareafieldbase',
		                	reference: 'observacionesRef',
		                	fieldLabel: HreRem.i18n('header.complemento.titulo.observaciones'),		
		                	name: 'observaciones',
		                	width: '400px'
	            		}
		    	  	]
		}];
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('activo', me.idActivo);
    }
});
    
    