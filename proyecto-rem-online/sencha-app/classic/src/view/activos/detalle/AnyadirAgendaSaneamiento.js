Ext.define('HreRem.view.activos.detalle.AnyadirAgendaSaneamiento', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadiragendasaneamientowindow',
    layout	: 'fit',
    /*width	: Ext.Element.getViewportWidth() / 3,*/    
    /*height	: Ext.Element.getViewportHeight() / 3,*/

    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    modoEdicion: true,
    
    idActivo: null,
    
    listeners: {
    	
		show: function() {			
			var me = this;
			me.resetWindow();			
		},
		boxready: function(window) {
			var me = this;
			me.initWindow();
		}
		
	},
	
	initWindow: function() {
    	var me = this;
    	
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
			);
    	}
    	
    },

    initComponent: function() {
    	
    	var me = this;
    	
    	me.setTitle(HreRem.i18n("title.anyadir.agenda"));
    	
    	me.buttons = [ { itemId: 'btnAnyadir', text: HreRem.i18n('itemSelector.btn.add.tooltip'), handler: 'onClickBotonAnyadirAgendaSaneamiento'}, 
    		{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarAgendaSaneamiento'}];
    	
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
				        	fieldLabel:  HreRem.i18n('header.patrimonio.contrato.tipologia'),
				        	reference: 'comboTipologiaRef',
				        	chainedStore: 'storeSubtipologiaAgendaSaneamiento',
							chainedReference: 'comboSubtipologiaRef',
				        	name: 'comboTipologia',
			            	bind: {
			            		store: '{storeTipologiaAgendaSaneamiento}'
			            	},
							publishes: 'value',									
    						listeners: {
								select: 'onChangeChainedCombo'
    						}
			    		},
			    		{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.agenda.revision.titulo.subtipologia'),	
				        	reference: 'comboSubtipologiaRef',
				        	name: 'comboSubtipologia',
			            	bind: {
			            		store: '{storeSubtipologiaAgendaSaneamiento}'
			            	},
			            	disabled: true
			    		},
			    		{
		                	xtype: 'textareafieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.agenda.revision.titulo.observaciones'),			                	
		                	name: 'descripcion',
		                	maxLength: 256			                	
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
    
    