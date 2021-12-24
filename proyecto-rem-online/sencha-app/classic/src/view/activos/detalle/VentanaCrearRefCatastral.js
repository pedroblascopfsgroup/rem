Ext.define('HreRem.view.activos.detalle.VentanaCrearRefCatastral', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanaCrearRefCatastral',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.2,
	reference: 'ventanaCrearRefCatastral',
	requires: ['HreRem.view.activos.detalle.InformacionCatastroGrid'],
	
	idActivo: null,
	
    refCatastral: null,
    
    parent: null,

    record: null,
    
    controller: null,
    
    modificar: null,
    
    initComponent: function() {
    	var me = this; 
    	var referenciaModificar = "";
    	var modificar= false;
    	if(Ext.isEmpty(me.refCatastral)){
    		me.setTitle(HreRem.i18n("fieldlabel.referencia.catastral.crear"));
    	}else{
    		me.setTitle(HreRem.i18n("fieldlabel.referencia.catastral.modificar"));
    		referenciaModificar = me.refCatastral;
    		modificar = true;  
    	}
    	
    	me.modificar = modificar;
    	
    	me.buttons = [ 
    		{ 
    			itemId: 'btnCancelar', 
    			text: 'Cancelar', 
    			handler: 'closeWindow', 
    			scope: this
    		},
    		{ 
    			formBind: true, 
    			itemId: 'btnGuardar', 
    			text: 'Guardar', 
    			reference: 'guardarRefCatastralRef',
    			handler: 'onClickGuardarReferencia',
    			disabled: true
    		}
    	];

    	me.items = [
    				{
	    				xtype: 'formBase',
	    				reference: 'createReferenciaCatastralRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'formbase_no_shadow',
	    				items: [
	    					{
		    					xtype:'fieldsettable',		    					
					        	colspan: 3,
		    					defaultType: 'textfieldbase',
		    					collapsible: false,
								collapsed: false,
								width: '100%',				    
		    					items: [
		    						  {
		  								xtype: 'textfield',
		  								fieldLabel: HreRem.i18n('fieldlabel.referencia.catastral'),
		  								name: ' buscarCatastro',
		  								margin: '10 10 10 10',
		  								reference: 'buscarCatastroRef',
		  								colspan: 3,
		  								allowBlank: false,
		  								width: 500,	
		  								minLength: 14,
		  								maxLength: 20,
		  								value: referenciaModificar,
		  								minLengthText: 'Debe tener 20 digitos',
		  								triggers: {									
	  										buscarEmisor: {
	  								            cls: Ext.baseCSSPrefix + 'form-search-trigger',
	  								            handler: 'buscarReferenciaCatastral' 
	  								        }
		  								},
		  								cls: 'searchfield-input sf-con-borde',
		  								emptyText:  'Referencia'
		  		                	},
		  		                	{
		    							xtype:'informacionCatastroGrid',
		    							colspan: 3,
		    							reference: 'informacionCatastroGridRefRem'
		    							
					    			},
					    			{
		    							xtype:'informacionCatastroGrid'	,
		    							colspan: 3,
		    							reference: 'informacionCatastroGridRefCat'
					    			}
					    		]
	    					}
	    				]
    				}
    	];

    	me.callParent();
    }
});