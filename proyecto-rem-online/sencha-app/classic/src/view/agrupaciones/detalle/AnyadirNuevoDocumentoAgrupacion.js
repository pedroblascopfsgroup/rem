Ext.define('HreRem.view.agrupaciones.detalle.AnyadirNuevoDocumentoAgrupacion', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirNuevoDocumentoAgrupacion',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 4,    


    controller: 'agrupaciondetalle',
    viewModel: {
        type: 'agrupaciondetalle'
    },
    
    idAgrupacion: null,
    grid: null,
    
    
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
		}
	},
    
	initComponent: function() {
    	
    	var me = this;
    	
    	me.buttons = [{ 
    					itemId: 'btnGuardar', 
    					text: 'Adjuntar', 
    					handler: 'onClickGuardarGastoRefacturado'
    				  },  
    				  { 
    					  itemId: 'btnCancelar', 
    					  text: 'Cancelar', 
    					  handler: 'onClickBotonCancelarGastoActivo'
    				  }];
    	
    	me.items = [
    		{
				
				xtype:'fieldset',
				cls	: 'panel-base shadow-panel',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 1,
			        trAttrs: {height: '50px', width: '100%'},
			        tdAttrs: {width: '100%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
						}
			        }
				},
				defaultType: 'textfieldbase',
				collapsed: false,
				scrollable	: 'y',
				cls:'',	    				
            	items: [
            	   
					{
						fieldLabel: HreRem.i18n('fieldlabel.archivo'),
						reference: 'documentoAgrupacion',
						width: 		'90%',
            	    	name:		'documentoAgrupacion'
						
            	    },
            	    {
						fieldLabel: HreRem.i18n('header.tipo'),
						reference: 'tipoDocumentoAgrupacion',
						width: 		'90%',
            	    	name:		'tipoDocumentoAgrupacion',
            	    	xtype: 		'comboboxfieldbase',
            	    	bind: {
							store: '{comboSiNoNSRem}'	            		
						}

		    		},
		    		{
						xtype: 'combobox',
			        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
			        	name:'tipoDocumentoAgrupacion',
			        	reference: 'tipoDocumentoAgrupacion',
			        	editable: true,
			        	msgTarget: 'side',
			        	bind: {
							store: '{tiposAdjuntoAgrupacion}'	            		
						},
		            	displayField	: 'descripcion',
					    valueField		: 'codigo',
						allowBlank: false,
						width: '100%',
						enableKeyEvents:true,
					    listeners: {
					    	'keyup': function() {
					    		this.getStore().clearFilter();
					    	   	this.getStore().filter({
					        	    property: 'descripcion',
					        	    value: this.getRawValue(),
					        	    anyMatch: true,
					        	    caseSensitive: false
					        	})
					    	},
					    	'beforequery': function(queryEvent) {
					         	queryEvent.combo.onLoad();
					    	}
					    }
			        },
			        {
	                	xtype: 'textarea',
	                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
	                	reference: 'descripcionDocumentoAgrupacion',
            	    	name:'descripcionDocumentoAgrupacion',
	                	maxLength: 256,
	                	msgTarget: 'side',
	                	width: '100%'
            		}
            	    

            	]
    		}
    	];
    	
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('fieldlabel.anyadir.gastos'));
    }
});