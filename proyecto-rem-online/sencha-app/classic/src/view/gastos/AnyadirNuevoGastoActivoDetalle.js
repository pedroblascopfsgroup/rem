Ext.define('HreRem.view.gastos.AnyadirNuevoGastoActivoDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevogastoactivodetalle',
    collapsed: false,
	scrollable	: 'y',
	cls:'',	  				
	recordName: "gastoActivo",						
	recordClass: "HreRem.model.GastoActivo",

    
	initComponent: function() {
    	
    	var me = this;
    	
    	
    	me.items = [
					{
						
								xtype:'fieldset',
								cls	: 'panel-base shadow-panel',
								layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 1,
							        trAttrs: {height: '45px', width: '100%'},
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
										fieldLabel: HreRem.i18n('fieldlabel.nuevo.activo.gasto'),
				            	    	name:		'numActivo',
										bind:		'{gastoActivo.numActivo}'
				            	    },
				            	    {
				            	    	fieldLabel: HreRem.i18n('fieldlabel.nuevo.agrupacion.gasto'),
				            	    	name:		'numAgrupacion',
										bind:		'{gastoActivo.numAgrupacion}'
				            	    }

				            	]
		    			   
		    		
				}
    	];
    	
    	me.callParent();
    	//me.setTitle(HreRem.i18n('title.nueva.oferta'));
    }
    
});