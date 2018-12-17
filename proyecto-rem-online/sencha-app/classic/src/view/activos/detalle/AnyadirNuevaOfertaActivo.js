Ext.define('HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevaofertaactivo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
    
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    requires: ['HreRem.model.OfertaComercialActivo', 'HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaDetalle'],
    
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
		},
		
		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},
    
	initComponent: function() {
    	
    	var me = this;
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonGuardarOferta'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarOferta'}];
    	
    	me.items = [
					{
						xtype: 'anyadirnuevaofertadetalle'/*, 
						collapsed: false,
					 	scrollable	: 'y',
						cls:'',	  
						
						recordName: "oferta",						
						recordClass: "HreRem.model.OfertaComercial",
						
						items: [
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
										bind:		'{oferta.idActivo}',
										hidden:		true
				            	    },
									{
										xtype:      'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.importe'),
										flex: 		1,
										bind:		'{oferta.importeOferta}'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('header.oferta.tipoOferta'),
	    					        	itemId: 'comboTipoOferta',
	    					        	flex:	1,
	    					        	bind: {
	    				            		store: '{comboTipoOferta}',
	    				            		value: '{oferta.tipoOferta}'
	    				            	},
	    				            	displayField: 'descripcion',
	    	    						valueField: 'codigo'
									}

				            	]
		    			   }
		    		]*/
				}
    	];
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('title.nueva.oferta'));
    },
    
    resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(me.oferta);
	
    }
    
});