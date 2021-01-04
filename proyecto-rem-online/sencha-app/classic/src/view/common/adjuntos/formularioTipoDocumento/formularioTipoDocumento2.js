Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.economicas.CondicionesEconomicasDetalle', {	
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'xtypeFormularioTipoDocumento2',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'xtypeFormularioTipoDocumento2',
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
		    	xtype: 'combosino',
		    	title: 'Aplica'
            },
            {
		    	xtype: 'Datefield',
		    	title: 'Fecha Emisión',
		    	name: 'fechaEmision'
            },
            {
		    	xtype: 'Datefield',
		    	title: 'Fecha Caducidad',
		    	name: 'fechaCaducidad'

            }
    ]
	});