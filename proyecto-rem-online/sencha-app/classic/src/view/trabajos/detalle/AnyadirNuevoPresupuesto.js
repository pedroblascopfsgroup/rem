Ext.define('HreRem.view.trabajos.detalle.AnyadirNuevoPresupuesto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevopresupuesto',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    //closable: true,		
    //closeAction: 'hide',
    
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
    
    requires: ['HreRem.model.PresupuestosTrabajo'],
    
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
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonGuardarPresupuesto'}, { itemId: 'btnActualizar', text: 'Actualizar', handler: 'onClickBotonActualizarPresupuesto'}, { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarPresupuesto'}];
    	
    	me.items = [
					{
						xtype: 'formBase', 
						collapsed: false,
					 	scrollable	: 'y',
						cls:'',	  
						
						recordName: "presupuesto",
						
						recordClass: "HreRem.model.PresupuestosTrabajo",
						
						items: [
		    			   {
								xtype:'fieldset',
								//title: HreRem.i18n('title.contabilidad'),
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
										bind:		'{presupuesto.id}',
										hidden:		true
				            	    },
									{
										xtype:      'displayfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.tipo.trabajo'),
										flex: 		1,
										bind:		'{presupuesto.tipoTrabajoDescripcion}'
									},
									{
										xtype:      'displayfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.subtipo.trabajo'),
										flex: 		1,
										bind:		'{presupuesto.subtipoTrabajoDescripcion}'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor'),
	    					        	itemId: 'comboProveedor',
	    					        	flex:	1,
	    					        	bind: {
	    				            		store: '{comboProveedor}',
	    				            		value: '{presupuesto.idProveedor}'
	    				            	},
	    				            	displayField: 'nombreComercial',
	    	    						valueField: 'idProveedor'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor'),
	    					        	itemId: 'comboProveedor',
	    					        	flex:	1,
	    					        	bind: {
	    				            		store: '{comboProveedor}',
	    				            		value: '{presupuesto.idProveedor}'
	    				            	},
	    				            	displayField: 'nombreComercial',
	    	    						valueField: 'idProveedor'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
	    					        	itemId: 'comboEstadoPresupuesto',
	    					        	flex:	1,
	    					        	bind: {
	    				            		store: '{comboEstadoPresupuesto}',
	    				            		value: '{presupuesto.estadoPresupuestoCodigo}'	    				            		
	    				            	},
	    				            	displayField: 'descripcion',
	    	    						valueField: 'codigo'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.referencia.presupuesto.proveedor'),
										flex: 		1,
										name:		'refPresupuestoProveedor',
										bind:		'{presupuesto.refPresupuestoProveedor}'
									},
									{
										xtype: 		'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.fecha'),
										flex: 		1,
										name:		'fecha',
										bind:		'{presupuesto.fecha}'
									},
									{
										xtype:		'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.importe'),
										flex: 		1,
										name:		'importe',
										bind:		'{presupuesto.importe}'
									},
									{
										xtype: 		'textareafieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.comentarios'),
										flex: 		1,
										name:		'comentarios',
										bind:		'{presupuesto.comentarios}'
									}
				            	]
		    			   }
		    		]
				}
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(me.presupuesto);
		me.setTitle(HreRem.i18n('title.anyadir.nuevo.presupuesto'));
    	
		me.down('button[itemId=btnGuardar]').setVisible(!me.modoEdicion);
		me.down('button[itemId=btnActualizar]').setVisible(me.modoEdicion);
		me.down('comboboxfieldbase[itemId=comboEstadoPresupuesto]').setVisible(me.modoEdicion);
		me.down('comboboxfieldbase[itemId=comboProveedor]').setVisible(!me.modoEdicion);
		
		
    }
});