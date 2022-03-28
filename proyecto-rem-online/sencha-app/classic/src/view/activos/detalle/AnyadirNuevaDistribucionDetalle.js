Ext.define('HreRem.view.activos.detalle.AnyadirNuevaDistribucionDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevadistribuciondetalle',
    reference	: 'anyadirNuevaDistribucionDetalle',
    collapsed: false,
	scrollable	: 'y',
	recordName: "distribucion",						
	recordClass: "HreRem.model.Distribuciones",

    
	initComponent: function() {
    	
    	var me = this;

    	
    	me.items = [
					{
				
						xtype:'fieldset',
						cls	: 'panel-base shadow-panel',
						layout: {
					        type: 'table',
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
		            	items: [
		            	    
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: 'Numero de planta',
					        	itemId: 'numPlanta',
								flex: 		1,
								reference: 'comboNumeroPlantas',
								chainedReference: 'comboTipoHabitaculo',
								chainedStore: 'comboNumeroPlantas',
								bind:{
									store: '{storeNumeroPlantas}'
								},
					        	allowBlank: false,
								displayField: 'descripcionPlanta',
								value: '-999',
	    						valueField: 'numPlanta',
					        	listeners:{
					        		change: 'onChangeChainedCombo'
					        	}
							},
							{
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  'Tipo de habitaculo',
					        	itemId: 'comboTipoHabitaculo',
					        	reference: 'comboTipoHabitaculo',					        	
					        	flex:	1,
					        	allowBlank: false,
					        	bind: {
					        		store: '{storeTipoHabitaculo}'
					        	},
					        	displayField: 'tipoHabitaculoDescripcion',
					        	valueField: 'tipoHabitaculoCodigo'
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('header.superficie'),
								reference: 'superficie',
								maskRe: /^(\d*\,?)\d*$/,
								itemId: 'superficie',
		            	    	allowBlank: true
		            	    },
		            	    {
								xtype: 'textfieldbase',
		            	    	fieldLabel: 'Cantidad',
								reference: 'cantidad',
								maskRe: /^\d*$/,
					        	itemId: 'cantidad',
					        	allowBlank: false
		            	    }
		            	]
    			   
    		
		}
    	];
    	me.callParent();
    	
    }
    
});