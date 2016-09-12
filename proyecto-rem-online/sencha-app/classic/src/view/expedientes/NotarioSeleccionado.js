Ext.define('HreRem.view.expedientes.NotarioSeleccionado', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'notarioseleccionado',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 2,    
    //height	: Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() - 50 ,
    //closable: true,		
    //closeAction: 'hide',
    
    idTrabajo: null,
    
    parent: null,
    		
    modoEdicion: null,
    
    presupuesto: null,
    
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    
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
    	
    	me.buttons = [ { itemId: 'btnCancelar', text: 'Cerrar', handler: 'onClickBotonCerrarNotarioDetalle'}];
    	
    	me.items = [
					{
						xtype:'fieldset',
								cls	: 'panel-base shadow-panel',
//								layout: {
//							        type: 'table',
//							        // The total column count must be specified here
//							        columns: 1,
//							        trAttrs: {height: '45px', width: '100%'},
//							        tdAttrs: {width: '100%'},
//							        tableAttrs: {
//							            style: {
//							                width: '100%'
//										}
//							        }
//								},
								defaultType: 'displayfieldbase',
								collapsed: false,
								collapsible: false,
									scrollable	: 'y',
								cls:'',	    				
				            	items: [
									
				            		{
										fieldLabel: HreRem.i18n('fieldlabel.nombre'),
										flex: 		1,
										bind:		'{notario.nombre}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.direccion'),
										flex: 		1,
										bind:		'{notario.direccion}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.personaContacto'),
										flex: 		1,
										bind:		'{notario.personaContacto}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.cargo'),
										flex: 		1,
										bind:		'{notario.cargo}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.telefono'),
										flex: 		1,
										bind:		'{notario.telefono}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.email'),
										flex: 		1,
										bind:		'{notario.email}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.provincia'),
										flex: 		1,
										bind:		'{notario.provincia}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
										flex: 		1,
										bind:		'{notario.tipoDocIdentificativo}'
									},
									{
										fieldLabel: HreRem.i18n('header.documento'),
										flex: 		1,
										bind:		'{notario.docIdentificativo}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
										flex: 		1,
										bind:		'{notario.codigoPostal}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.fax'),
										flex: 		1,
										bind:		'{notario.fax}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
										flex: 		1,
										bind:		'{notario.telefono2}'
									}
									
									

				            	]
						
				}
    	];
    	
    	me.callParent();
    	me.setTitle(HreRem.i18n('title.detalle.notario'));
    },
    
    resetWindow: function() {
    	var me = this;
    	me.getViewModel().set('notario', me.notario);
    }
    
});