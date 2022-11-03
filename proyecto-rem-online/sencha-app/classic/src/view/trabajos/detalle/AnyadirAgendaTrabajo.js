Ext.define('HreRem.view.trabajos.detalle.AnyadirAgendaTrabajo', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadiragendatrabajo',
    layout	: 'fit',
    /*width	: Ext.Element.getViewportWidth() / 3,*/    
    /*height	: Ext.Element.getViewportHeight() / 3,*/

    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    
    idTrabajo: null,
    
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
    	
    	me.setTitle(HreRem.i18n("title.anyadir.agenda"));
    	
    	me.buttons = [ { itemId: 'btnAnyadir', text: HreRem.i18n('itemSelector.btn.add.tooltip'), handler: 'onClickBotonAnyadirAgendaTrabajo'}, 
    		{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarVentanaAgendaTrabajo'}];
    	
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
				        	fieldLabel:  HreRem.i18n('fieldlabel.tipoGestion'),
				        	reference: 'comboTipoGestionRef',
				        	name: 'comboTipoGestion',
				        	store: new Ext.data.Store({
								model: 'HreRem.model.ComboBase',
								proxy: {
									type: 'uxproxy',
									remoteUrl: 'generic/getTipoApunteByUsuarioLog'/*,
									extraParams: {diccionario: 'tipoApunte'}*/
								},
								autoLoad: true
							}),
			            	/*bind: {
			            		store: '{storeTipoTituloComplemento}'
			            	},*/
			            	width: '400px',
							publishes: 'value',									
    						allowBlank: false
			    		},
	            		{
		                	xtype: 'textareafieldbase',
		                	reference: 'observacionesRef',
		                	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),		
		                	name: 'observaciones',
		                	width: '400px',
		                	allowBlank: false
	            		}
		    	  	]
		}];
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('trabajo', me.idTrabajo);
    }
});
