Ext.define('HreRem.view.expedientes.BuscarComparecienteDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'buscarcomparecientedetalle',
    collapsed: false,
	scrollable	: 'y',
	cls:'',	  				
//	recordName: "oferta",						
//	recordClass: "HreRem.model.OfertaComercial",

    
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
								collapsible: false,
									scrollable	: 'y',
								cls:'',	    				
				            	items: [
									{
										fieldLabel: HreRem.i18n('fieldlabel.nombre'),
										flex: 		1,
										bind:		'{busquedaCompereciente.nombre}'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.comparecencia'),
	    					        	itemId: 'comboTipoCompareciente',
	    					        	flex:	1,
	    					        	bind: {
	    				            		store: '{comboTipoCompareciente}',
	    				            		value: '{busquedaCompereciente.tipoCompareciente}'
	    				            	},
	    				            	displayField: 'descripcion',
	    	    						valueField: 'codigo'
									},
									{
										xtype: 'button',
										text: HreRem.i18n('fieldlabel.buscar'),
									    margin: '10 10 10 10',
									    handler: 'onClickBotonBuscarCompareciente'
									    //disabled: true // TODO Comités sin definir
									}
									
									

				            	]
		    			   
		    		
					},
					{
						
					    xtype		: 'gridBase',
					    title: HreRem.i18n('title.comparecientes.nombre.vendedor'),
					    reference: 'listadocomparecientesnombrevendedor',
						cls	: 'panel-base shadow-panel',
						topBar: true,
						requires: ['HreRem.view.expedientes.buscarCompareciente'],
						bind: {
							store: '{storeBusquedaComparecientes}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('fieldlabel.tipo.comparecencia'),
					        	dataIndex: 'tipoCompareciente',
					        	flex: 1
					       },
						   {    text: HreRem.i18n('fieldlabel.nombre'),
					        	dataIndex: 'nombre',
					        	flex: 1
					       },						   
						   {
					            text: HreRem.i18n('header.direccion'),
					            dataIndex: 'direccion',
					            flex: 1
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.telefono'),
					            dataIndex: 'telefono',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.email'),
					            dataIndex: 'email',
					            flex: 1						   
						   }
					    ]
					
					}
    	];
    	
    	me.callParent();
    	//me.setTitle(HreRem.i18n('title.nueva.oferta'));
    }
    
});