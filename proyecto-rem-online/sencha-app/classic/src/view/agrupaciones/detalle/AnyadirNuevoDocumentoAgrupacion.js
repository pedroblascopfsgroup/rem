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
						fieldLabel: HreRem.i18n('fieldlabel.configuracion.perfiles.descripcion'),
						reference: 'descripcionDocumentoAgrupacion',
            	    	name:		'descripcionDocumentoAgrupacion',
            	    	xtype: 		'textareafieldbase',
						height: 	60,
						width: 		'90%',
						maxWidth:	600,
						margin: 	'0 10 10 0'
						
            	    }
            	    

            	]
    		}
    	];
    	
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('fieldlabel.anyadir.gastos'));
    }
});