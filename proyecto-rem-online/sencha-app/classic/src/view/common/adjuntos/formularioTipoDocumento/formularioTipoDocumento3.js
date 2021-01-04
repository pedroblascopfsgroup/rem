Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.CondicionesEconomicasDetalle', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'xtypeFormularioTipoDocumento3',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento3',
    layout: 'form',
    isEditForm: true,
    autoScroll: true,
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'displayfield'
    },
    
    items: [
    	
            {
		    	xtype: 'Datefield',
		    	title: 'Fecha Obtención',
		    	name: 'fechaObtencion'
		    		
            },
            {
		    	xtype: 'Datefield',
		    	title: 'Fecha Caducidad',
		    	name: 'fechaCaducidad'
            },
            {
		    	xtype: 'Datefield',
		    	title: 'Fecha Etiqueta',
		    	name: 'fechaEtiqueta'

            },
            {
		    	xtype: 'combobox',
		    	title: 'Fecha Etiqueta',
		    	name: 'fechaEtiqueta',
		    		store: Ext.create('Ext.data.Store',{								        		
		    			model: 'HreRem.model.ComboBase',
						proxy: {
							type: 'uxproxy',
							remoteUrl: 'generic/getDiccionario',
							extraParams: {diccionario: 'calificacionEnergetica'}
						},
						autoLoad: true
					})	

            },
            {
		    	xtype: 'textfieldbase',
		    	title: 'Registro',
		    	name: 'registro'

            }
    ]
	});