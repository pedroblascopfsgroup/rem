Ext.define('HreRem.view.precios.historico.HistoricoPropuestasSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'historicopropuestassearch',
    reference	: 'historicoPropuestasSearch',  
  	layout: {
        type: 'table',
        // The total column count must be specified here
        columns: 4,
        trAttrs: {height: '30px', width: '100%'},
        tdAttrs: {width: '25%'},
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
        
        me.setTitle(HreRem.i18n("title.historico.filtro.propuestas"));
        
        me.buttons = [{ text: 'Buscar', handler: 'onSearchHistoricoClick' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
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
			        style: 'width: 25%',
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
										fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
										name: 'entidadPropietariaCodigo',
										bind: {
											store: '{comboEntidadPropietaria}'
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
										fieldLabel: HreRem.i18n('fieldlabel.tipo.propuesta'),
										name: 'tipoPropuesta',
										bind: {
											store: '{comboTiposPropuesta}'
										}
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.numero.tramite'),
									    name: 'numTramite'        	
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.num.trabajo'),
									    name: 'numTrabajo'        	
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
										bind: {
											disabled: '{!comboTipoFecha.selection}'
										}
									},									
									{
										xtype: 'datefieldbase',
										name: 'fechaHasta',
										fieldLabel: HreRem.i18n('fieldlabel.hasta'),
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
										name:	'estadoPropuesta',
										bind: {
											store: '{comboEstadosPropuesta}'
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

