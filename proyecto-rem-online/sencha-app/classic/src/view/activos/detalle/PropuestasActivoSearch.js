Ext.define('HreRem.view.activos.detalle.PropuestasActivoSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'propuestasactivosearch',
  	layout: {
        type: 'table',
        // The total column count must be specified here
        columns: 3,
        trAttrs: {height: '30px', width: '100%'},
        tdAttrs: {width: '33%'},
        tableAttrs: {
            style: {
                width: '100%'
				}
        }
	},
    
    defaults: {
		
    	xtype: 'textfieldbase',
    	addUxReadOnlyEditFieldPlugin: false
    },  

    initComponent: function () {
        
        var me = this;
        
        me.buttons = [{ text: 'Buscar', handler: 'onSearchPropuestasActivoClick' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
        me.buttonAlign = 'left';
        
        var items = [
        
        {
        	    xtype: 'panel',
 				minHeight: 100,
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        style: 'width: 33%',
			        addUxReadOnlyEditFieldPlugin: false
			    },
	    		
			    items: [
			    	    
				            {
			            	    defaults: {	
							    	xtype: 'textfieldbase',
							    	addUxReadOnlyEditFieldPlugin: false
							    }, 
				            	items: [   
		
									{
										fieldLabel: HreRem.i18n('fieldlabel.num.propuesta'),
									    name: 'numPropuesta'        	
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.nombre.propuesta'),
									    name: 'nombrePropuesta'        	
									},
									{ 
									    xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.tipo.propuesta'),
										name: 'tipoPropuesta',
										bind: {
											store: '{comboTiposPropuesta}'
										}
									}
									/*,
									{ 
									    xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
										name: 'entidadPropietariaCodigo',
										bind: {
											store: '{comboEntidadPropietaria}'
										}
									}*/
									
								]
				            },
				            {
			            	    defaults: {	
							    	xtype: 'textfieldbase',
							    	addUxReadOnlyEditFieldPlugin: false
							    }, 				            	
				            	items: [
				            		{ 
										xtype: 'comboboxfieldbase',
										reference: 'comboTipoFecha',
										fieldLabel:  HreRem.i18n('fieldlabel.tipo.fecha'),
										name:	'tipoDeFecha',
										bind: {
											store: '{comboTiposFecha}'
										}
									},
									{
										xtype: 'datefieldbase',
										reference: 'datefielddesde',
										name: 'fechaDesde',
										fieldLabel:  HreRem.i18n('fieldlabel.desde'),
										publish: 'value',
										formatter: 'date("d/m/Y")',
										bind: {
											disabled: '{!comboTipoFecha.selection}'
										}
									},									
									{
										xtype: 'datefieldbase',
										name: 'fechaHasta',
										fieldLabel: HreRem.i18n('fieldlabel.hasta'),
										formatter: 'date("d/m/Y")',
										bind: {
											disabled: '{!comboTipoFecha.selection}',
											minValue: '{datefielddesde.value}'
										}
									}				            	
				            	]
				            },
				            {
			            	    defaults: {	
							    	xtype: 'textfieldbase',
							    	addUxReadOnlyEditFieldPlugin: false
							    }, 				            	
				            	items: [

									{
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.estado.propuesta'),
										name:	'estadoCodigo',
										bind: {
											store: '{comboEstadosPropuesta}'
										}				
									},
									{
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.estado.activo.propuesta'),
										name:	'estadoActivoCodigo',
										bind: {
											store: '{comboEstadosPropuestaActivo}'
										}
										
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.gestor.precios'),
									    name: 'gestorPrecios'  			
									}
									/*
									,{ // TODO Gestores de precios
										xtype: 'comboboxfieldbase',
										fieldLabel: 'Gestor'										
									}*/
				            	
				            	]
				            }
		         ]
        }

        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

