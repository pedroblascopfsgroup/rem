Ext.define('HreRem.view.gastos.AnyadirNuevoGastoRefacturado', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevogastorefacturado',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 5,    


    controller: 'gastodetalle',
    viewModel: {
        type: 'gastodetalle'
    },
    
    idGasto: null,
    grid: null,
    nifPropietario: null,    
    
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
    					text: 'Añadir', 
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
            	    	name:		'id',
						bind:		'{gastoActivo.id}',
						hidden:		true
            	    },
					
					{
						fieldLabel: HreRem.i18n('fieldlabel.numero.de.gastos'),
						reference: 'anyadirGastoRefacturado',
            	    	name:		'numGastoARefacturar'
						//bind:		'{gastoActivo.numActivo}'
            	    }

            	]
    		}
    	];
    	
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('fieldlabel.anyadir.gastos'));
    }
});