Ext.define('HreRem.view.mantenimiento.tiposmantenimiento.AnyadirMantenimiento', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirmantenimientowindow',
    layout	: 'fit',

    controller: 'mantenimientoscontroller',
    viewModel: {        
        type: 'mantenimientosmodel'
    },
    
    modoEdicion: true,
        
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
    	
    	me.setTitle(HreRem.i18n("title.anyadir.mantenimiento"));
    	
    	me.buttons = [ { itemId: 'btnAnyadir', text: HreRem.i18n('itemSelector.btn.add.tooltip'), handler: 'onClickBotonAnyadirMantenimiento'},  
    					{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'hideWindowCrearMantenimiento'}]; 
    	
    	me.items = [ //TODO
				{
					xtype: 'formBase', 
					collapsed: false,
					layout: {
						type: 'table',
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
							name: 'codCartera',
		              		fieldLabel :  HreRem.i18n('fieldlabel.entidad.propietaria'),
		              		reference: 'codCarteraRef',
							bind: {
								store: '{comboCartera}'
							},
		            		publishes: 'value',
		            		listeners:
		            			{
		            			change: 'onSelectComboCodCartera'
		            		},
		            		allowBlank: false
						},
					{ 
		        		xtype: 'comboboxfieldbase',
			        	name: 'codSubCartera',
			        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
			        	reference: 'codSubCarteraRef',
			        	bind: {
		            		store: '{comboSubcartera}',
		            		disabled: '{!codCarteraRef.selection}',
		            		filters: {
		            			property: 'carteraCodigo',
		                        value: '{codCarteraRef.value}'
		            		}
			        	},
			        	publishes: 'value'		
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.propietario'),
						reference: 'codPropietarioRef',
						name: 'codPropietario',
						bind: {
							store: '{comboPropietario}',
							disabled: '{!codCarteraRef.selection}'							
						},
						displayField: 'nombre',
						valueField: 'id'
					},
			        { 
			        	xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.cartera.macc'),
						reference: 'carteraMaccRef',
		            	name: 'carteraMacc', 
			        	bind: 
			        		{store: '{comboSiNoRem}'}
			        }
		    	  	]
		}];
    	
    	me.callParent();
    	
    },
    
    resetWindow: function() {
    	var me = this;
    }
});
    
